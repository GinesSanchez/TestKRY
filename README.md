# KRY app code assignment

I have divided this test in two parts:

1. Add features

For this part, I have assumed that I just join the project and that the current implementation has been decided by the team that I just joined. So, what I have done is adding the feature respecting the base code as much as I can.

- Add cache for the data.
- Add Add new weather location.
- Delete weather location.

2. Add Nice to have (optional)

The current implementation of the code can be improved. In that part, what I have done is refactoring the code with things that I thought that can help to have a better code.

- Change project organization.
- Rename view controllers and controllers.
- Make view model delegate of the view controller.
- Add network manager and weather manager for handleling the requests to the backend.

There is a commit for each feature in the master branch that I have done.

Things that I think that it would be nice to have but I didn't have time:

- Add unit tests to the network manager and the weather manager with real and mock data.
- Add coordinator for handleling the navigation. Add unit tests.
- Add factory for the creation of the view modules.
- Add table animations.
- Improve the desing of the Add weather location view.
- Add unit tests to the view models.
- Handle weather manager errors in the view model to show an specific message.
- Move show alert view from the view controllers to an UIView extension e.g.





