module Puavo
  module Connection
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      # Set base (organsiation) and bind by logged in user to ldap server.
      def ldap_setup_connection(host, base, dn, password)
        setup_connection( ensure_configuration.merge( { "host" => host,
                                                        "base" => base,
                                                        "bind_dn" => dn,
                                                        "password" => password } ) )

        # Updated subclasses base value.
        LdapBase.subclasses.each  do |_subclass|
          Class.class_eval(_subclass).base = base
        end
      end
    end
  end
end
