# To keep a check on Unused CSS which may be present

begin
  require 'deadweight'
	rescue LoadError
end

desc "run Deadweight CSS check (requires script/server)"
task :deadweight do
  dw = Deadweight.new
  dw.stylesheets = ["/assets/application.css","/assets/landing-page.css","/assets/posts.css.scss"]
  dw.pages = ["/","/events/index","/contact","/about","/invitations","/groups","/groups/:group_id/posts/","/admin/users"]
  dw.ignore_selectors = /flash_notice|flash_error|errorExplanation|fieldWithErrors/
  puts dw.run
end