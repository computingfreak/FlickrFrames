
## FlickrFrames

**FlickrFrames** is a basic iOS project that fetches images from Flickr and renders them in **UICollectionView**.  The project does not use any third-party libraries and is built using all native components



## Features

 - Enter text to search for images from Flickr

 - Infinite scrolling with so many images

 - Faster scrolling (uses basic image caching)



## Screenshots

<div id="imagesMain">

  <img src="https://github.com/vinayakparmar92/FlickrFrames/blob/master/Simulator%20Screen%20Shot%20-%20iPhone%206s%20-%202018-09-02%20at%2014.01.06.png" width=30% hspace="5">

  <img src="https://github.com/vinayakparmar92/FlickrFrames/blob/master/Simulator%20Screen%20Shot%20-%20iPhone%206s%20-%202018-09-02%20at%2014.01.18.png" width=30% hspace="5">

  <img src="https://github.com/vinayakparmar92/FlickrFrames/blob/master/Simulator%20Screen%20Shot%20-%20iPhone%206s%20-%202018-09-02%20at%2014.01.41.png" width=30% hspace="5">

</div>



## Architecture

**FlickrFrames** follows basic MVVM design pattern. It consists of Models, Views, ViewModels, and ViewControllers. Here communication from ViewModels to View is done through Callbacks *(Reactive pattern is recommended)*. Since Unit Testing was a higher priority for this project, MVVM works very well to make that combined with **Dependency Injection**.



Since *pictures are worth a thousand words*, attaching here a few images which shows the class sequence diagram of most of the functionality. Hope that saves your time while reviewing the code



### MVVM
Class sequence showing communication between classses
<img src="https://github.com/vinayakparmar92/FlickrFrames/blob/master/FlickrFrames%20iOS%20Project%20Class%20Sequence%20Diagram%20(1).png"/>


### Networking and Service
<img src="https://github.com/vinayakparmar92/FlickrFrames/blob/master/Network%20layer.png"/>


### Image Caching

Have implemented image caching using **NSCache**.  The cache gets cleared manually when the app receives Memory Warning. Also the cache is cleared by OS when app shuts. Its the behaviors of NSCache. **URLCache**

is the other option that can also be used if more control is required.



### Unit tests

Test cases are written for major functionalities. Below here mentioned are name and description of all cases

	

	testImagesFetchSuccessResponseModelDecodingFromMock()

> An offline test to check if success model decoding is working fine.Codable is used to map JSON data to models

		

	testImagesFetchErrorResponseDecodingFromMock()

> An offline test to check if error model decoding is working fine. Codable is used to map JSON data to models

		

	testImagesLoadFlowFromServer()

> To test the complete image load flow from the server. This helps if any issue with data parsing or zero images or API is down

		

	testSearchImageFlowFromMockedData()

> Test the complete search flow from Mocked data



	testImageDownloadAndCaching()

> Test the caching functionality of Image Caching Helpers

## Shortcuts



 - Have used Interface builder for creating layouts. Could have created everything programmatically(in **loadView()**) for better performance. We use to do that in Zomato Restaurant app and it makes a noticeable difference to scroll performance. 

 - The method to initialize**rootViewController** in AppDelegate is very straightforward. It gets more complicated as the app features evolve. Could have used some common manager to handle all the navigation/routing part.

 - Should have used Reactive pattern communicated from ViewModel to View.

 - A separate framework or target for all the network layer code can be done. It makes the framework reusable between projects and maintains a line of modularity. We had that structure in Zomato where we had different projects like ZUIKit, ZUINetwork etc. Uber has multiple apps, so they can have separate frameworks for UI, Networking and Service layers and other core functionality.

 - A better app user experience. Like already loading some images(which are trending) when the app begins. Having a different screen to search images which also shows search suggestions(trending searches) when UISearchBar is active



## Time estimates

The overall app took me about 13-15 hours including meal breaks :). It seems a bit difficult task to complete in 5 hours considering quality in mind. Unit testing and writing this **ReadMe**  file also contributed to that time. 



## My Takeaways

It was an interesting project to implement. A tricky problem I faced was the images in the collection view were flickering when it's scrolled. It was because the cells are reused and some earlier Image load call completes later and updates the image. It took some thoughts to fix that. I had to keep up a reference to the **sessionTask** so that I can cancel if any previous call is running.

