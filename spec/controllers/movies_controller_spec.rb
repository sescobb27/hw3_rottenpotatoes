require 'spec_helper'
def on_index
    get :index
end
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
        end
        it "should list all movies" do
          on_index
          expect(response.status).to be 200
          expect(response).to render_template :index
          expect(assigns[:movies]).to eq([movies])
        end

        it "should be unorder" do
            pending
        end
        it "should order movies by release date" do
            pending
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
end
