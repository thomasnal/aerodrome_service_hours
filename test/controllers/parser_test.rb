require 'test_helper'

describe ParserController do
  let(:input_file) { fixture_file_upload('input/notamn3.in', 'text') }

  it 'must get index' do
    get :index
    assert_response :success
  end

  it 'must post upload via html' do
    post :upload, :format => :html, :input_file => input_file
    assert_response :success
    assert_not_nil assigns(:notamns)
  end

  it 'must post upload via js' do
    post :upload, :format => :js, :input_file => input_file
    assert_response :success
    assert_not_nil assigns(:notamns)
  end

  it 'must respond with success to upload with nil file' do
    post :upload, :format => 'html'
    assert_response :success
    assert_nil assigns(:notamns)
  end
end
