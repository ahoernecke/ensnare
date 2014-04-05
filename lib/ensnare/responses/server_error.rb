class Ensnare::Response::ServerError < Ensnare::Response::Response    
  
    def run
        @controller.render(:file => File.join(Rails.root, 'public/500.html'), :status => 500, :layout => false)
        return true
    end

end