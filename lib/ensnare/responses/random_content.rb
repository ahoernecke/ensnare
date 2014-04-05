class Ensnare::Response::RandomContent < Ensnare::Response::Response    

    def run
        o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
        string = (0...Random.rand(50000)).map{ o[rand(o.length)] }.join

        @controller.render :text=>string, :layout=>true
        return true
    end

end