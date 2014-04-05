class Ensnare::Response::Redirect < Ensnare::Response::Response    

    def run
        @controller.redirect_to  @options[:url]
        return true
    end

end