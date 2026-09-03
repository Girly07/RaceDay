# RaceDay API Endpoint Plan

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| **Authentication** ||||||
| POST | `/api/auth/register` | Register a new user (Participant or Organiser). | Public (none) | `{ "firstName", "lastName", "email", "password", "role" }` | 201 Created – `{ "userId", "email", "role" }` <br> 400 Bad Request – validation errors <br> 409 Conflict – email already exists |
| POST | `/api/auth/login` | Authenticate user and return a JWT token. | Public (none) | `{ "email", "password" }` | 200 OK – `{ "token", "userId", "role" }` <br> 401 Unauthorized – invalid credentials |
| **User Profile** ||||||
| GET | `/api/users/me` | Retrieve the authenticated user's profile. | Any logged-in user | None | 200 OK – `{ "userId", "firstName", "lastName", "email", "role", "createdAt" }` <br> 401 Unauthorized – missing/invalid token |
| PUT | `/api/users/me` | Update the authenticated user's own profile. | Any logged-in user | `{ "firstName", "lastName", "email" }` (optional) | 200 OK – updated user object <br> 400 Bad Request – validation errors <br> 409 Conflict – email already taken |
| **Events** ||||||
| GET | `/api/events` | List all events (supports filtering by status, date, organiser). | Public (none) | None (query params optional) | 200 OK – array of event objects |
| GET | `/api/events/{id}` | Get details of a specific event, including its categories. | Public (none) | None | 200 OK – event object with `categories` array <br> 404 Not Found – event does not exist |
| POST | `/api/events` | Create a new event. | Organiser | `{ "name", "description", "eventDate", "location", "status" }` | 201 Created – new event object <br> 400 Bad Request – validation errors <br> 403 Forbidden – user is not an organiser |
| PUT | `/api/events/{id}` | Update an existing event (only the organiser who created it). | Organiser (owner) | `{ "name", "description", "eventDate", "location", "status" }` | 200 OK – updated event <br> 403 Forbidden – not the organiser <br> 404 Not Found |
| DELETE | `/api/events/{id}` | Delete an event (only the organiser who created it). | Organiser (owner) | None | 204 No Content <br> 403 Forbidden – not the organiser <br> 404 Not Found |
