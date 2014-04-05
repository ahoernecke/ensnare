class Ensnare::Response::Throttle < Ensnare::Response::Response    

    def run
        sleep(@options[:min_delay] + ((@options[:max_delay] == @options[:min_delay]) ? 0 : Random.rand(@options[:max_delay] - @options[:min_delay])))
        return false
    end

end