class Admin::BaseController < ApplicationController
  layout 'admin/application'

  before_filter :restrict_access
  skip_before_filter :restrict_access, :only => ['elfinder']

  def index
  end

  def elfinder
    path = ['system', 'elfinder']
    home = 'Home'
    thumbs = false
    if (!params['folder'].blank?)
      folder = params['folder'].downcase
      path << folder
      home = folder.capitalize
      thumbs = folder == 'images'
    end
    h, r = ElFinder::Connector.new(
      :root => File.join(*([Rails.public_path] + path)),
      :url => '/' + path.join('/'),
      :home => home,
      :upload_max_size => '10M',
      :thumbs => thumbs,
      :perms => {
        /^(Welcome|README)$/ => {:read => true, :write => false, :rm => false},
        '.' => {:read => true, :write => true, :rm => false}, # '.' is the proper way to specify the home/root directory.
        /^test$/ => {:read => true, :write => true, :rm => false},
        'logo.png' => {:read => true},
        /\.png$/ => {:read => false} # This will cause 'logo.png' to be unreadable.  
                            # Permissions err on the safe side. Once false, always false.
      },
      :extractors => { 
        'application/zip' => ['unzip', '-qq', '-o'], # Each argument will be shellescaped (also true for archivers)
        'application/x-gzip' => ['tar', '-xzf'],
      },
      :archivers => { 
        'application/zip' => ['.zip', 'zip', '-qr9'], # Note first argument is archive extension
        'application/x-gzip' => ['.tgz', 'tar', '-czf'],
      }
    ).run(params)
    headers.merge!(h)
    render (r.empty? ? {:nothing => true} : {:text => r.to_json}), :layout => false
  end

  helper_method :page_list
  
  private

    def page_list
      @pages || Page.all
    end 

    def restrict_access
      unless current_user && current_user.role?(:admin)
        flash[:notice] = 'Please sign in to access this page.'
        redirect_to signin_path
      end
    end

end
