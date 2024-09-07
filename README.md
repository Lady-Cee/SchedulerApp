# MyScheduler

MyScheduler is a task management application built with Flutter. It helps you organize, prioritize, and schedule tasks efficiently, ensuring you stay on top of your daily, weekly, or monthly activities.
Features
•	Add, Edit, Delete Tasks: Manage your tasks effortlessly by adding new tasks, editing existing ones, or deleting completed or irrelevant tasks.
•	Task Priority: Assign priorities to tasks (e.g., Low, Medium, High) to help you focus on what's most important.
•	Due Date & Time: Schedule tasks with specific due dates and times. The app provides a user-friendly date and time picker.
•	Notifications & Alarms: Get notified 10 minutes before a task is due. The app also reads out the task title and description using text-to-speech functionality.
•	Checkbox Selection: Select tasks using checkboxes for bulk deletion or editing.
•	Persistence: Tasks are saved locally using SharedPreferences, ensuring they persist even after the app is closed or restarted.
•	Blinking Error Message: Error messages blink to draw attention to incomplete or incorrect input during task creation or editing.


Usage
•	Adding a Task:
o	Enter the task title and description.
o	Select a due date and time.
o	Choose the task priority.
o	Click the "Add Task" button.
•	Editing a Task:
o	Tap the edit icon next to a task.
o	Modify the task details in the form that appears.
o	Click "Save" to apply the changes.
•	Deleting a Task:
o	Tap the delete icon next to a task to remove it.
o	You can also select multiple tasks using the checkboxes and delete them all at once by tapping the delete button.

•	Shared Preferences: Tasks are stored locally using SharedPreferences. You can adapt this to use other storage solutions by modifying the TaskStorage interface and its implementation in lib/features/shared_preference_task_storage.dart.
Known Issues
•	On some devices, the checkbox may not disappear immediately after deselecting a task.

Contributions
Contributions are welcome! If you have suggestions for improvements or new features, feel free to create a pull request or open an issue.
License


Acknowledgments
•	Special thanks to Anthony Ameh and Tindi for their mentorship; and Atinuke and Barr. Nonso for their review.
•	Thanks to Tech4Dev for providing the platform to learn and build this app.
________________________________________
