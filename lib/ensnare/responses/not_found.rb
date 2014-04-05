class Ensnare::Response::NotFound < Ensnare::Response::Response    


    def run
        raise ActionController::RoutingError.new('Not Found')
        return true
    end

end