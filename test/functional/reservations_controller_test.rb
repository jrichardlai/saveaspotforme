require 'test_helper'

class ReservationsControllerTest < ActionController::TestCase
  setup do
    @reservation = reservations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reservations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reservation" do
    assert_difference('Reservation.count') do
      post :create, reservation: { address: @reservation.address, city: @reservation.city, latitude: @reservation.latitude, longitude: @reservation.longitude, phone: @reservation.phone, remote_task_id: @reservation.remote_task_id, restaurant_name: @reservation.restaurant_name, user_id: @reservation.user_id, yelp_id: @reservation.yelp_id, zip: @reservation.zip }
    end

    assert_redirected_to reservation_path(assigns(:reservation))
  end

  test "should show reservation" do
    get :show, id: @reservation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @reservation
    assert_response :success
  end

  test "should update reservation" do
    put :update, id: @reservation, reservation: { address: @reservation.address, city: @reservation.city, latitude: @reservation.latitude, longitude: @reservation.longitude, phone: @reservation.phone, remote_task_id: @reservation.remote_task_id, restaurant_name: @reservation.restaurant_name, user_id: @reservation.user_id, yelp_id: @reservation.yelp_id, zip: @reservation.zip }
    assert_redirected_to reservation_path(assigns(:reservation))
  end

  test "should destroy reservation" do
    assert_difference('Reservation.count', -1) do
      delete :destroy, id: @reservation
    end

    assert_redirected_to reservations_path
  end
end
