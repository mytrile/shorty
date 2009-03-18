require 'rubygems'
require 'sequel'

DB = Sequel.connect('postgres://username:password@localhost:5432/shorty')

DB.create_table :data do
  primary_key :id
  column :url, :text
  column :surl, :text
end