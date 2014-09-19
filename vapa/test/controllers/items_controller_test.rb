require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  setup do
    @item = items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item" do
    assert_difference('Item.count') do
      post :create, item: { description: @item.description, item_class: @item.item_class, item_subclass: @item.item_subclass, last_seen: @item.last_seen, lifetime_until: @item.lifetime_until, lup: @item.lup, owner: @item.owner, price: @item.price, purchased_at: @item.purchased_at, purchased_at_date: @item.purchased_at_date, rfid: @item.rfid, serial: @item.serial, service_interval: @item.service_interval, sku: @item.sku, tagid: @item.tagid, warranty_until: @item.warranty_until, weight: @item.weight }
    end

    assert_redirected_to item_path(assigns(:item))
  end

  test "should show item" do
    get :show, id: @item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item
    assert_response :success
  end

  test "should update item" do
    patch :update, id: @item, item: { description: @item.description, item_class: @item.item_class, item_subclass: @item.item_subclass, last_seen: @item.last_seen, lifetime_until: @item.lifetime_until, lup: @item.lup, owner: @item.owner, price: @item.price, purchased_at: @item.purchased_at, purchased_at_date: @item.purchased_at_date, rfid: @item.rfid, serial: @item.serial, service_interval: @item.service_interval, sku: @item.sku, tagid: @item.tagid, warranty_until: @item.warranty_until, weight: @item.weight }
    assert_redirected_to item_path(assigns(:item))
  end

  test "should destroy item" do
    assert_difference('Item.count', -1) do
      delete :destroy, id: @item
    end

    assert_redirected_to items_path
  end
end
