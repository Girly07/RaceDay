# RaceDay API Endpoint Plan

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| **Authentication** ||||||
| POST | `/api/auth/register` | Register a new user (Participant or Organiser). | Public (none) | `{ "firstName", "lastName", "email", "password", "role" }` | 201 Created – `{ "userId", "email", "role" }` <br> 400 Bad Request – validation errors <br> 409 Conflict – email already exists |
| POST | `/api/auth/login` | Authenticate user and return a JWT token. | Public (none) | `{ "email", "password" }` | 200 OK – `{ "token", "userId", "role" }` <br> 401 Unauthorized – invalid credentials |
