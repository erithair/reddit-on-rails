require 'rails_helper'

RSpec.describe LinksController, :type => :controller do
  shared_examples_for 'public access' do
    describe "GET #show" do
      it "assigns a Link to @link" do
        pending "not implemented"
        link = create(:link)
        get :show, id: link
        expect(assigns(:link)).to eq link
        expect(response).to render_template :show
      end
    end

    describe "GET #index" do
      it "assigns links to @links" do
        link1 = create(:link)
        link2 = create(:link)
        get :index
        expect(assigns(:links)).to match_array([link1, link2])
        expect(response).to render_template :index
      end
    end
  end

  shared_examples_for 'logged-in access' do
    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      it "creates a new link" do
        expect {
          post :create, link: attributes_for(:link, user: @user)
        }.to change(@user.links, :count).by(1)
        expect(response).to redirect_to links_path
      end
    end

    describe "GET #edit" do
      it "assigns a Link to @link" do
        link = create(:link, user: @user)
        get :edit, id: link
        expect(assigns(:link)).to eq link
        expect(response).to render_template :edit
      end

      it "can not edit other user's link" do
        link = create(:link)
        get :edit, id: link
        expect(response).to redirect_to links_path
      end
    end

    describe "PATCH #update" do
      before :each do
        @link = create(:link, user: @user, title: 'Old Title')
      end

      context "with valid attributes" do
        it "updates the data" do
          patch :update, id: @link, link: attributes_for(:link,
            title: 'New Title',
            user: @link.user)
          @link.reload
          expect(@link.title).to eq 'New Title'
          expect(response).to redirect_to link_path(@link)
        end
      end

      context "with invalid attributes" do
        it "not update the data" do
          patch :update, id: @link, link: attributes_for(:link,
            url: @link.url,
            title: '',
            user: @link.user)
          @link.reload
          expect(@link.title).to eq 'Old Title'
          expect(response).to render_template :edit
        end
      end

      it "can not update other user's link" do
        patch :update, id: create(:link), link: attributes_for(:link)
        expect(response).to redirect_to links_path
      end
    end

    describe "DELETE #destroy" do
      it "delete the link" do
        link = create(:link, user: @user)
        expect {
          delete :destroy, id: link
        }.to change(@user.links, :count).by(-1)
        expect(response).to redirect_to links_path
      end

      it "can not delete other user's link" do
        link = create(:link)
        expect {
          delete :destroy, id: link
        }.to_not change(Link, :count)
        expect(response).to redirect_to links_path
      end
    end
  end

  describe "public user" do
    it_behaves_like 'public access'

    describe "GET #new" do
      it "requires login" do
        get :new
        expect(response).to require_login
      end
    end

    describe "POST #create" do
      it "requires login" do
        expect {
          post :create, link: attributes_for(:link)
        }.to_not change(Link, :count)
        expect(response).to require_login
      end
    end

    describe "GET #edit" do
      it "requires login" do
        get :edit, id: create(:link)
        expect(response).to require_login
      end
    end

    describe "PATCH #update" do
      it "requires login" do
        patch :update, id: create(:link), link: attributes_for(:link)
        expect(response).to require_login
      end
    end

    describe "DELETE #destroy" do
      it "requires login" do
        link = create(:link)
        expect {
          delete :destroy, id: link
        }.to_not change(Link, :count)
        expect(response).to require_login
      end
    end
  end

  describe "logged-in user" do
    before :each do
      @user = create(:user)
      set_user_session @user
    end

    it_behaves_like 'public access'
    it_behaves_like 'logged-in access'
  end
end
