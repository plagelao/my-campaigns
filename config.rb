# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

File.read('.env').lines do |line|
  name, value = line.split('=')
  ENV[name] = value
end

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :contentful do |f|
  f.space         = {rpg: ENV['SPACE']}
  f.access_token  = ENV['SECRET_TOKEN']
  f.cda_query     = {limit: 100}
  f.content_types = {
    campaign: 'campaign'
  }
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

if data.respond_to?('rpg')
  data.rpg.campaign.each do |id, campaign|
    # Assumes the file source/about/template.html.erb exists
    proxy "/#{campaign.slug}.html", "/campaign/template.html", locals: { campaign: campaign }
    campaign.npcs.each do |npc|
      proxy "/#{campaign.slug}/#{npc.slug}.html", "/npc/template.html", locals: { npc: npc }
    end
  end
end

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
