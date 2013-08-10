require 'spec_helper'
def on_new
    get :new
end

describe MoviesController do
    describe "GET #index" do
        let!(:movies) { mock_model('Movie') }
        before(:each) do
            Movie.stub(
            all_ratings: %w(G PG PG-13 NC-17 R),
            find_all_by_rating: [movies]
            )
            selected_ratings = Movie.all_ratings
            date_header = 'hilite'
        end

        it "should list all movies" do
            get :index
            expect(response.status).to be 200
            expect(response).to render_template :index
            expect(assigns[:movies]).to eq([movies])
        end

        it "should redirect to index" do
            params = {
                sort: 'release_date',
                ratings: {
                    'G' => '1',
                    'PG' => '1',
                    'PG-13' => '1',
                    'NC-17' => '1',
                    'R' => '1'
                }
            }
            get :index, params
            assigns[:selected_ratings]
            assigns[:date_header]
            assigns[:ordering]
            response.should redirect_to sort: params[:sort], ratings: params[:ratings]
        end
        it "should order movies by release_date" do
            params = {
                sort: 'release_date',
                ratings: {
                    'G' => '1',
                    'PG' => '1',
                    'PG-13' => '1',
                    'NC-17' => '1',
                    'R' => '1'
                }
            }
            ordering = {order: :release_date}

            session[:sort] = params[:sort]
            session[:ratings] = params[:ratings]

            Movie.should_receive(:find_all_by_rating).
                with(params[:ratings].keys, ordering)

            get :index, params

            assigns[:date_header]
            assigns[:selected_ratings]
            assigns[:ordering]
            
            expect(session[:sort]).to eql params[:sort]
            expect(session[:ratings]).to eql params[:ratings]
            response.should render_template(:index)
            expect(assigns[:movies]).to eql([movies])
            
        end
        it "should order movies by title" do
            pending
        end
        it "should filter movies" do
            pending
        end
    end

    describe "POST #create" do
        let!(:movie) { stub_model(Movie) }
        before(:each) do
            Movie.stub(:new).and_return(movie)
        end
        it "should send new  message  to Movies class" do
            params = {
                        'title' => 'X-Men',
                        'director' => 'Stan Lee',
                        'rating' => 'G',
                        'release_date' => '1971-03-11'
                    }
            Movie.should_receive(:new).with(params)
            post :create, movie: params
        end

        it "should send save message to movie model" do
            movie.should_receive(:save)
            post :create
        end

        context "when save message returns true" do
            before(:each) do
                Movie.stub(:save).and_return(true)
            end
            it "should send title message to movie model" do
              Movie.stub(:title)
              movie.should_receive(:title)
              post :create
            end
            it "should redirect_to index" do
               post :create
               expect(response).to redirect_to movies_path
            end
            it "should assigns a success flash message" do
                post :create
                expect(flash[:notice]).not_to be_nil
            end
        end

        context "when save message returns false" do
            before(:each) do
                Movie.stub(:save).and_return(false)
            end
            it "should re-render the new view" do
                movie.should_receive(:save)
                post :create
                response.should render_template action: 'new'
                expect(flash[:notice]).not_to be_nil
            end
        end
    end

    describe "PUT #Update" do
        let!(:movie) { stub_model(Movie) }
        before(:each) do
            Movie.stub(:find).and_return(movie)
        end

        describe "find movies" do
            it "should be in edit page" do
                params = {
                    id: '1'
                }
                Movie.should_receive(:find).with(params[:id])
                get :edit, params
                response.should render_template :edit
            end

            it "should update movies director" do
                params = {
                    id: '1',
                    movie: {
                        'director'=> 'Stan Lee'
                    }
                }
                Movie.should_receive(:find).with(params[:id])
                movie.should_receive(:update_attributes!).with(params[:movie])
                put :update, params
            end

            it "should display flash" do
                params = {
                    id: '1'
                }
                flash.should_not be(nil)
                put :update, params
            end

            it "should redirect to show movie path" do
                params = {
                    id: '1'
                }
                put :update, params
                response.should redirect_to(movie_path(movie))
            end
        end
        it "updated movies director should be the same requested" do
            params = {
                id: '1',
                movie: {
                    'director' => 'Stan Lee'
                }
            }
            put :update, params
            assigns([:movie])
            expect(movie.director).to eql params[:movie]['director']
        end
    end

    describe "GET #Same_director" do
        let!(:movie) { stub_model(Movie) }
        before(:each) do
            Movie.stub(:find).and_return(movie)
            movie.stub(:release_date).and_return(Time.zone.parse '1977-05-25 00:00:00')
            movie.stub(:title).and_return('Star Wars')
        end
        context "movies with same director" do
            describe "find" do
                it "should send find message to Movie.class" do
                    params = {
                        id: '1'
                    }
                    Movie.should_receive(:find).with(params[:id])
                    get :show, params
                    response.should render_template(:show)
                    assigns[:movie]
                end
                it "should see other movies with same director" do
                    params = {
                        title: 'Star Wars'
                    }
                    Movie.stub_chain(:select, :where, :first) do
                        mock_model("Movie", director: 'George Lucas')
                    end
                    movies = Movie.stub(:find_all_by_director).and_return [
                        mock_model("Movie", title: 'Star Wars'),
                        mock_model("Movie", title: 'THX-1138')
                    ]
                    get :same_director, params
                    response.should render_template(:same_director)
                    assigns[:movies]
                    response.body.should have_content("Star Wars")
                    response.body.should have_content("THX-1138")
                    response.body.should_not have_content("Blade Runner")
                    
                end
            end

            describe "can't find" do
                it "should redirect if not movies were found"do
                    params = {
                        title: 'Invalid'
                    }
                    Movie.stub_chain(:select, :where, :first) do
                        nil
                    end
                    get :same_director, params
                    expect(response).to redirect_to(movies_path)
                    expect(flash).not_to be_nil
                end
                it "should show flash 'movie title' has no director info" do
                    params = {
                        title: 'Alien'
                    }
                    Movie.stub_chain(:select, :where, :first) do
                        mock_model("Movie", director: '')
                    end
                    get :same_director, params
                    expect(response).to redirect_to(movies_path)
                    expect(flash[:notice]).to eql "'Alien' has no director info"
                end
            end
        end
    end
end
