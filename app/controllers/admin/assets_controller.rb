module Admin
  class AssetsController < MagnetismController
    actions :all

    protected
      alias :begin_of_association_chain :current_site
  end
end
