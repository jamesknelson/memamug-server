class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos, id: :uuid do |t|
      t.uuid :contact_id, null: false

      t.attachment :image

      t.timestamps null: false
    end
  end
end
