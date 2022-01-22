require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(name: "User-1", email: "user-1@test.com")
  end

  test "should get index" do
    get clients_url
    assert_response :success
  end

  test "should get new" do
    get new_client_url
    assert_response :success
  end

  test "should create client" do
    assert_difference("Client.count") do
      post clients_url, params: { client: { email: "new#{@user.email}", name: "new#{@user.name}" } }
    end

    assert_redirected_to client_url(Client.last)
  end

  test "should show client" do
    get client_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_url(@user)
    assert_response :success
  end

  test "should update client" do
    patch client_url(@user), params: { client: { email: 'Update', name: "Update" } }
    assert_redirected_to client_url(@user)
  end

  test "should destroy client" do
    assert_difference("Client.count", -1) do
      delete client_url(@user)
    end

    assert_redirected_to clients_url
  end
end
