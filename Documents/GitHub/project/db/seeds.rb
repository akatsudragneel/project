# This file should contain all the record creation needed to seed the database with its default values.
#The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

r1 = Role.create({name: "Regular", description: "Can read items"})
r2 = Role.create({name: "Admin", description: "Can read and create items. Can update and destroy own items"})
r3 = Role.create({name: "Superadmin", description: "Can perform any CRUD operation on any resource"})

u1 = User.create({name: "Superadmin", email: "superadmin@example.com", password: "123456", password_confirmation: "123456", role_id: r3.id, approved: 't',confirmed_at: Time.now.utc})

u2 = User.create({name: "Admin",email: "admin@example.com", password: "123456", password_confirmation: "123456", role_id: r2.id, approved: "t",confirmed_at: Time.now.utc})

u3 = User.create({name: "Regular",email: "regular@example.com", password: "123456", password_confirmation: "123456", role_id: r1.id, approved: "t",confirmed_at: Time.now.utc})
