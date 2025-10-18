   // Fetch data from your REST API
   fetch('/api/mybooks')
  .then(response => response.json())
  .then(books => {
    // Use books array to render UI dynamically
    console.log(books);
  });