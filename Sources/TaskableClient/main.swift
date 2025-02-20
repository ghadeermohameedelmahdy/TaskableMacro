import Taskable

@Taskable
private func fetchData() async {
   await navigateToLogin()
}

@MainActor
func navigateToLogin() {
    
}

// Run the function inside an async environment

struct MainApp {
    static func main() {
      fetchData()
    }
}
