class MainController

  def initialize
    @store_helper = StoreHelper.new
  end

  def run
    MainViewer.welcome
    get_store
  end

  private

  def get_store
    user_input = MainViewer.ask_address.downcase

    if user_input == "exit"
      MainViewer.bye
    else
      closest_store = @store_helper.find_store(user_input)
      if closest_store.nil?
        MainViewer.display_error
      else
        MainViewer.show_store(closest_store)
      end

      get_store
    end
  end

end
