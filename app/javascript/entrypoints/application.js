// Import the main stylesheet with custom components
import '../stylesheets/application.scss'

// Load Rails libraries
import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'

// Start Rails
Rails.start()
Turbolinks.start()
ActiveStorage.start()

// Initialize AlpineJS
import Alpine from 'alpinejs'
window.Alpine = Alpine
Alpine.start()

// Import SweetAlert2
import Swal from 'sweetalert2'
window.swal = Swal

// Import boxicons
import 'boxicons'

// Import application logic
import '../lib/main.js'
