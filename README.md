# Blog Application

A RESTful API blog application built with Ruby on Rails.

## Features

- User authentication using JWT
- Post management (Create, Read, Update, Delete)
- Comment system
- Tag system
- Automatic post deletion after 24 hours
- Background job processing with Sidekiq
- Caching with Redis
- API documentation with Swagger

## Requirements

- Docker
- Docker Compose
- Ruby 3.2.0 or later
- PostgreSQL 15
- Redis

## Installation

1. Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/blog_app.git
cd blog_app
```

2. Copy environment file:

```bash
cp .env.example .env
```

3. Modify `.env` file according to your needs

4. Start the application:

```bash
docker-compose up
```

## Usage

After starting the application, you can access:

- Application: http://localhost:3000
- API: http://localhost:3000/api/v1
- API Documentation: http://localhost:3000/api-docs
- Sidekiq Dashboard: http://localhost:3000/sidekiq

## API Endpoints

### Authentication

- `POST /api/v1/signup` - Register a new user
- `POST /api/v1/login` - Login user

### Posts

- `GET /api/v1/posts` - List all posts
- `POST /api/v1/posts` - Create a new post
- `GET /api/v1/posts/:id` - Get a specific post
- `PUT /api/v1/posts/:id` - Update a post
- `DELETE /api/v1/posts/:id` - Delete a post

### Comments

- `POST /api/v1/posts/:post_id/comments` - Add a comment to a post
- `PUT /api/v1/posts/:post_id/comments/:id` - Update a comment
- `DELETE /api/v1/posts/:post_id/comments/:id` - Delete a comment

## Testing

To run the test suite:

```bash
docker-compose run web bundle exec rspec
```

## Development

### Prerequisites

- Ruby 3.2.0
- PostgreSQL 15
- Redis
- Docker and Docker Compose

### Setup Development Environment

1. Install dependencies:

```bash
bundle install
```

2. Setup database:

```bash
rails db:create db:migrate
```

3. Start services:

```bash
docker-compose up
```

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Security

- All API endpoints (except authentication) require JWT token
- Passwords are encrypted using bcrypt
- Rate limiting is implemented
- CORS is configured
- Security headers are set

## Performance

- Database queries are optimized
- N+1 queries are prevented
- Background jobs for heavy tasks
- Redis caching for frequently accessed data

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Ruby on Rails team
- PostgreSQL team
- Redis team
- Sidekiq team
- All contributors
# blog_app
