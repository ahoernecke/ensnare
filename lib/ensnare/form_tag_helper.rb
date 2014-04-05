

module ActionView
  module Helpers
    module FormHelper
      #Overload form_for to pass in the object name as part of the options hash
      def form_for_with_trap(record, options = {}, &block)
        options[:html] ||= {}
        
        case record
        when String, Symbol
          options[:html][:object_name]  = record
          
        else
          object = record.is_a?(Array) ? record.last : record
          options[:html][:object_name]  = options[:as] || ActiveModel::Naming.param_key(object)
        end
        
        
        form_for_without_trap(record, options, &block)

      end
      
      alias_method_chain :form_for, :trap
    end

    module FormTagHelper
      #Overload form_tag to insert a hidden parameter called "admin" with a value of false
      #Assuming a real "admin" attribute is not accessible, this will throw a mass assignment
      #error when submitted

      def form_tag_with_trap(url_for_options = {}, options = {}, *parameters_for_url, &block)
        
        object_name = options.delete(:object_name)
        honeypot = options.delete(:honeypot)
        html = form_tag_without_trap(url_for_options, options, *parameters_for_url, &block)

        if(Ensnare.mode == :enforce || Ensnare.mode == :log)
        
          #puts "url_for_options: " + url_for_options.inspect
          #puts "options: " + options.inspect
          #puts "paramaters_for_url: " + parameters_for_url.inspect
          
          object_name ||= controller_name.tableize.singularize.to_s
          

          session[:ensnare] ||= {}
          session[:ensnare][:params] ||= {}

          
            # :admin => this sets a cookie named admin with a boolean value set to false
            # :debug => this sets a cookie named debug with a boolean value set to false
            # :random => this cookie generates a random N character cookie with a random encrypted value
            # :uid => this sets a series of parameters that look like UIDs and GIDs

          if(trap = Ensnare.enabled_traps.find{|trap| trap[:type] == :parameter})
            predefined_parameters = trap.try(:[],:options).try(:[],:predefined_parameters) || []
            predefined_parameters.each do |p|
               k = v = nil
              case p
              when :admin
                k="admin"
                v="false"
              when :debug
                k="debug"
                v="false"
              when :random
                k="random"
                v= session[:ensnare][:params][k.to_s] || SecureRandom.hex
              when :gid
                k="gid"
                v= session[:ensnare][:params][k.to_s] || Random.rand(100000)
              when :uid
                k="uid"
                v= session[:ensnare][:params][k.to_s] || Random.rand(100000)
              end
              if( !k.nil? && !p.nil? )                
                session[:ensnare][:params][k.to_s] = v.to_s
                trap_parameter = text_field_tag(object_name.to_s+"[#{k.to_s}]", v.to_s, options.except(:class).stringify_keys.merge({:id=>object_name.to_s+"_#{k.to_s}"}).update("type" => "hidden"))
                if block_given?
                  html.insert(html.index('>')+1, trap_parameter)
                  #html.insert(html.index('</form>'), trap_parameter)
                else
                  html = trap_parameter+html
                end   
              end
            end

            parameter_names = trap.try(:[],:options).try(:[],:parameter_names) || {}
            parameter_names.each do |k,v|
              if(v.class == Method)
                v = session[:ensnare][:params][k.to_s] || v.call 
              end
              session[:ensnare][:params][k.to_s] = v
              trap_parameter = text_field_tag(object_name.to_s+"[#{k.to_s}]", v.to_s, options.except(:class).stringify_keys.merge({:id=>object_name.to_s+"_#{k.to_s}"}).update("type" => "hidden"))
              if block_given?
                html.insert(html.index('>')+1, trap_parameter)
                #html.insert(html.index('</form>'), trap_parameter)
              else
                html = trap_parameter+html
              end
              
            end
          end
        end
        #end
        html
      end
      alias_method_chain :form_tag, :trap

    private

    
    end
  end
end