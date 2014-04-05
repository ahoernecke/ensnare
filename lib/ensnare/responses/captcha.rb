class Ensnare::Response::Captcha < Ensnare::Response::Response    

    def run
        
        @session[:ensnare] ||={}

        if(!@violations.blank?)
            @session[:ensnare].delete(:captcha_solved)
        end
        
        if(@session[:ensnare].try(:[],:captcha_solved) != true)
            @controller.redirect_to Ensnare::Engine.routes.url_helpers.captcha_path
            return true
        end

        return false

    end

end