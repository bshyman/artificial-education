window.updateXp = async (xp, userId) => {
    console.log('Updating XP to', xp)
    const url = `/users/${userId}/update_xp`
    console.log({url})
    const response = await fetch(url, {
        method: 'PATCH',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({
            xp: xp
        })
    })

    if (response.ok) {
        console.log('XP updated successfully')
    }
}

window.shuffle = array => {
    let currentIndex = array.length, randomIndex;
    // While there remain elements to shuffle.
    while (currentIndex > 0) {
        // Pick a remaining element.
        randomIndex = Math.floor(Math.random() * currentIndex);
        currentIndex--;
        // And swap it with the current element.
        [array[currentIndex], array[randomIndex]] = [
            array[randomIndex], array[currentIndex]];
    }
    return array;
}

// window.flashSuccess = message => {
//     swal.fire({
//         icon: 'success',
//         title: 'Success',
//         text: message
//     })
// }
window.flashSuccess = (message, type) => {
    const Toast = swal.mixin({
        toast: true,
        position: "top-end",
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
            toast.onmouseenter = swal.stopTimer;
            toast.onmouseleave = swal.resumeTimer;
        }
    });
    Toast.fire({
        icon: type,
        title: message
    })
}
document.addEventListener('alpine:init', () => {

})

