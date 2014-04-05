class Ensnare::Response::Block < Ensnare::Response::Response    

    def run
        @controller.render 'ensnare/violations/show'
        return true
    end

end