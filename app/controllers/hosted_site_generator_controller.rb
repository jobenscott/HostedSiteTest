class HostedSiteGeneratorController < ApplicationController
	require 'open-uri'
  def new_site
  	





  end

  def create_site
     oauth_token = ENV.fetch('GITHUB_OAUTH_TOKEN')
    
    github = Github.new oauth_token: oauth_token
    app_name = params[:hosted_site_data]["business_data"]["business_name"].to_s
     main_dir = Dir.pwd

    Dir.chdir('tmp')


    Dir.chdir('templates')

    github.repos.create "name": app_name, "org": "RailsCreator"

    system 'git clone https://'+oauth_token+'@github.com/jobenscott/template_test_1.git'

    # change into template director
    Dir.chdir('template_test_1')

    # set template app directory
    template_app_directory = Dir.pwd

    # change into models
    Dir.chdir('app/models')


    repair_setting = nil
    buyback_setting = nil
    # set features
    params[:hosted_site_data]["template_and_features"]["features"].each do |key,value|

      if value["feature"] == "repair"
        repair_setting = value["active"].to_s
      elsif value["feature"] == "buyback"
        buyback_setting = value["active"].to_s
      end
    end


    features_model_data = "class SiteFeatures < ApplicationRecord
    FEATURE_REFERENCE_DATA = {
    :repair => {
      :display_name => 'repair',
      :hosted_site_value => 0,
      :active => "+repair_setting+"
    },
    :buyback => {
      :display_name => 'buyack',
      :hosted_site_value => 1,
      :active => "+buyback_setting+"
    }
    }
    end"

    add_features = Thread.new do 
      system 'echo "'+features_model_data+'" > site_features.rb'
    end
    add_features.join

     # change back to app director
    Dir.chdir(template_app_directory)

    Dir.chdir('db')
    # ADD INITIAL USER

    base_url = request.base_url

    seeds_data = '"include SendgridHelper
    user = User.new
user.password = SecureRandom.hex
raw_token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
user.reset_password_token = hashed_token
user.reset_password_sent_at = Time.now.utc
user.email = \"aaroneveleth@gmail.com\"
user.save!
reset_url = \"https://'+app_name+'.herokuapp.com/users/edit?reset_password_token=\"+raw_token
SendgridHelper.test(reset_url, user.email)
"'


    add_seeds_data = Thread.new do
      system 'echo '+seeds_data+' > seeds.rb'
    end
    add_seeds_data.join
    # /ADD INITIAL USER

     # change back to app director
    Dir.chdir(template_app_directory)
   

    git_remove_origin = Thread.new do
      system 'git remote remove origin'
    end

    git_remove_origin.join
    
    git_initialize = Thread.new do
        system 'git init;git add .;git add -A; git commit -m "initial commit for '+app_name+'";git remote add origin https://jobenscott:'+oauth_token+'@github.com/RailsCreator/'+app_name+'.git'
    end
    git_initialize.join


    git_push = Thread.new do 
      system 'git push origin master'
    end

    git_push.join

     # HEROKU STUFF
    # start new thread for heroku app creation
     heroku_creation = Thread.new do
      system "heroku create "+app_name
    end
    # wait for heroku app creation to finish
    heroku_creation.join

    # push to heroku app
    heroku_push = Thread.new do
      system "git push heroku master"
    end

    # wait for heroku push
    heroku_push.join

    # heroku bundle
    heroku_bundle = Thread.new do
      system "heroku run bundle install"
    end

    # wait for heroku bundle install
    heroku_bundle.join

    # heroku db migration
    heroku_db_migration = Thread.new do
      system "heroku rake db:migrate"
    end

    # wait for heroku db migration
    heroku_db_migration.join

    # heroku db seed
    heroku_db_seed = Thread.new do
      system "heroku rake db:seed"
    end

    # wait for heroku db migration
    heroku_db_seed.join

    Dir.chdir('..')

    remove_generated_app = Thread.new do
      system 'rm -rf template_test_1'
    end

    remove_generated_app.join

    Dir.chdir(main_dir)

    p Dir.pwd
  end

  def payment_plan

  end

  def choose_template_and_features
  	template_and_features = {}

  	template_and_features["template"] = {
  		:owner => HostedSiteTemplate::TEMPLATE_REFERENCE_DATA[:"#{params[:template_key]}"][:owner],
  		:repo => HostedSiteTemplate::TEMPLATE_REFERENCE_DATA[:"#{params[:template_key]}"][:repo]
  	}

  	template_and_features["features"] = params[:features]
  	
  	respond_to do |format|
  		format.json {
  			render :js => template_and_features.to_json
  		}
  	end
  end
end
