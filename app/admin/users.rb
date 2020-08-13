ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # active_admin_import  validate: false,
  #                           csv_options: {col_sep: ";" },
  #                           before_import: ->(importer){ User.delete_all },
  #                           batch_size: 1000
  csv do
    column :id
    column :name
    column :email
    column :created_at
    column :updated_at
  end

   active_admin_import validate: false,
            #csv_options: {col_sep: ";" },
            resource_class: ImportedUser ,  # we import data into another resource
            before_import: ->(importer){  ImportedUser.delete_all },
            after_import:  ->(importer){
                User.transaction do
                    User.delete_all
                    User.connection.execute("INSERT INTO users (name, email, created_at, updated_at) SELECT name, email, created_at, updated_at FROM imported_users")
                end
            }
            # ,
            # back: -> {  config.namespace.resource_for(User).route_collection_path } # redirect to post index

  permit_params :name, :email
  # active_admin_import validate: false,
  #           csv_options: {col_sep: ";" },
  #           resource_class: ImportedUser ,  # we import data into another resource
  #           before_import: ->(importer){  ImportedUser.delete_all },
  #           after_import:  ->(importer){
  #               User.transaction do
  #                   User.delete_all
  #                   User.connection.execute("INSERT INTO users (SELECT * FROM imported_users)")
  #               end
  #           },
  #           back: -> {  config.namespace.resource_for(User).route_collection_path } # redirect to post index
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
