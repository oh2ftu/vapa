class RemoveNullsAddDefaults < ActiveRecord::Migration
  def change
        change_column_null :comments, :price, false
        change_column_default :comments, :price, 0
        change_column_null :comments, :service, false
        change_column_default :comments, :service, false
        change_column_null :comments, :inspection, false
        change_column_default :comments, :inspection, false
        change_column_null :items, :tagid, false
        change_column_null :items, :price, false
        change_column_default :items, :price, 0
        change_column_null :items, :last_seen, false
        change_column_default :items, :last_seen, Time.now
        change_column_null :items, :tagged, false
        change_column_default :items, :tagged, false
        change_column_null :items, :lup, false
        change_column_default :items, :lup, false
        change_column_null :items, :lup_inc, false
        change_column_default :items, :lup_inc, false
        change_column_null :items, :life_time, false
        change_column_default :items, :life_time, 0
        change_column_null :items, :warranty_time, false
        change_column_default :items, :warranty_time, 0
        change_column_null :items, :service_interval, false
        change_column_default :items, :service_interval, 0
        change_column_null :items, :inspection_interval, false
        change_column_default :items, :inspection_interval, 0
        change_column_null :vendors, :billing, false
        change_column_default :vendors, :billing, false

  end
end
