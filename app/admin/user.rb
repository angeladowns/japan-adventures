ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation,:username

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :created_at
    column :current_sign_in_at
    column :sign_in_count
    actions
  end

  filter :username
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :username
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
