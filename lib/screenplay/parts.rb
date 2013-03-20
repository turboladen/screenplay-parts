require 'screenplay/part'
Dir[File.dirname(__FILE__) + '/parts/*.rb'].each(&method(:require))
