class Ensnare::Response::RedirectLoop < Ensnare::Response::Response    


    def run
        @options[:parameter] ||= "id"
        @controller.redirect_to Ensnare::Engine.routes.url_helpers.redir_path @options[:parameter].to_sym=>Random.rand(1000000)
        return true
    end

end