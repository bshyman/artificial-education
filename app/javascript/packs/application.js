// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
require("@rails/ujs").start()
// require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
// import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
// import * as ActiveStorage from "@rails/activestorage"
// import "channels"

// import 'alpine-turbo-drive-adapter'
import Alpine from 'alpinejs'



// import tailwind into javascript
import "../stylesheets/application.scss"

// Rails.start()
// Turbolinks.start()
// ActiveStorage.start()


import Swal from 'sweetalert2'
window.swal = Swal
import './main.js'

window.Alpine = Alpine
window.Alpine.start()

