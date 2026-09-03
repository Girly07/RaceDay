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
| **Categories** ||||||
| GET | `/api/categories` | List all global categories. | Public (none) | None | 200 OK – array of categories |
| POST | `/api/categories` | Create a new global category. | Organiser | `{ "name", "description", "distanceKm" }` | 201 Created – category object <br> 400 Bad Request – validation errors |
| PUT | `/api/categories/{id}` | Update a global category. | Organiser | `{ "name", "description", "distanceKm" }` | 200 OK – updated category <br> 404 Not Found |
| DELETE | `/api/categories/{id}` | Delete a global category (if not used in any event). | Organiser | None | 204 No Content <br> 409 Conflict – category is in use |
| **Event Categories (linking)** ||||||
| GET | `/api/events/{eventId}/categories` | Get all categories linked to a specific event. | Public (none) | None | 200 OK – array of event-category objects |
| POST | `/api/events/{eventId}/categories` | Add an existing category to an event. | Organiser (owner) | `{ "categoryId", "startTime", "maxParticipants", "price" }` | 201 Created – event-category object <br> 400 Bad Request – category already linked <br> 404 Not Found |
| DELETE | `/api/events/{eventId}/categories/{categoryId}` | Remove a category from an event. | Organiser (owner) | None | 204 No Content <br> 404 Not Found |
| **Event Enrolments** ||||||
| POST | `/api/events/{eventId}/categories/{categoryId}/enrol` | Enrol a participant in a specific event category. | Participant | `{ "paymentStatus" (optional) }` | 201 Created – enrolment object <br> 400 Bad Request – already enrolled or event closed <br> 404 Not Found <br> 409 Conflict – capacity full |
| GET | `/api/events/{eventId}/enrolments` | Get all enrolments for an event (organiser view). | Organiser (owner) | None | 200 OK – array of enrolments with participant details |
| GET | `/api/users/me/enrolments` | Get the authenticated participant's own enrolments. | Participant | None | 200 OK – array of enrolments with event & category details |
| GET | `/api/enrolments/{id}` | Get a specific enrolment by ID. | Any logged-in (participant or organiser) | None | 200 OK – enrolment object <br> 403 Forbidden – not allowed <br> 404 Not Found |
| **Results** ||||||
| POST | `/api/events/{eventId}/results` | Upload results for multiple enrolments (organiser). | Organiser (owner) | `{ "results": [ { "enrolmentId", "finishTime", "position", "status" } ] }` | 201 Created – array of result objects <br> 400 Bad Request – enrolment already has result <br> 404 Not Found |
| PUT | `/api/results/{id}` | Update an existing result (organiser). | Organiser (owner) | `{ "finishTime", "position", "status" }` | 200 OK – updated result <br> 404 Not Found |
| GET | `/api/events/{eventId}/results` | Get all results for an event (public). | Public (none) | None | 200 OK – array of results with participant names and categories |
| GET | `/api/users/me/results` | Get the authenticated participant's own results (history). | Participant | None | 200 OK – array of results with event/category details |
| PUT | `/api/enrolments/{id}/cancel` | Cancel an enrolment. | Participant or Organiser (owner) | None | 200 OK – updated enrolment with status 'Cancelled' <br> 403 Forbidden – not allowed <br> 404 Not Found |
