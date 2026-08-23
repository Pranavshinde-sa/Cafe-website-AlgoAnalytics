# Assignment Video

This video is full process of Dockerization cafe application

**Demo video**

https://drive.google.com/file/d/1n0VVGiQdliowrNS5Yo_OFdPB2R3RdW_l/view?usp=sharing

# Application Overview

The application is a small **Python Flask-based Cafe Directory** that allows users to browse cafe information and view individual cafe details. Users can also add new cafes and edit existing cafe information through web forms.

The application uses **Flask** as the web framework, **Flask-SQLAlchemy with SQLite** for database operations, and **Flask-WTF/WTForms** for form handling and CSRF protection. It also includes HTML templates and static CSS/images for the web interface.

For **AlgoAnalytics** assignment, the application was containerized using **Docker** and configured to run on **port 5000**.


# Assignment Objective

The following objectives were completed successfully:

* Forked an existing open-source Flask application.
* Understood the application's architecture and components.
* Identified and configured the required project dependencies.
* Created a Dockerfile to containerize the application.
* Built the Docker image successfully.
* Ran the Flask application inside a Docker container.
* Configured the application to run on port `5000`.
* Verified the application's functionality through a web browser.
* Identified and resolved dependency compatibility issues.
* Documented the complete containerization, deployment, and troubleshooting process.


# Project Structure

```text
Cafe-website-algoanalytics/
├── main.py
├── requirements.txt
├── Dockerfile
├── .dockerignore
├── .env.example
├── cafes.db
├── templates/
│   └── ... HTML templates
└── static/
    ├── styles/
    └── images/
```

### Relevant Files

* **`main.py`** — Main Flask application.
* **`requirements.txt`** — Python dependencies required by the application.
* **`Dockerfile`** — Instructions for building the Docker image.
* **`.dockerignore`** — Files excluded from the Docker build context.
* **`.env.example`** — Example environment variable configuration.
* **`cafes.db`** — SQLite database containing café data.
* **`templates/`** — HTML templates used by the Flask application.
* **`static/`** — CSS and image files used by the web interface.


## Steps Followed to Complete the Assignment

1. **Selected and Forked the Application**

   * Selected an existing open-source Flask application.
   * Forked the repository to my GitHub account.
   * Cloned the repository and prepared it for Docker deployment.

2. **Analyzed the Application**

   * Reviewed the Flask application structure.
   * Identified `main.py` as the application entry point.
   * Identified SQLite as the database.
   * Reviewed the Python dependencies.

3. **Configured Application Dependencies**

   * Reviewed the existing `requirements.txt`.
   * Identified compatibility issues between the older Flask application and newer dependency versions.
   * Added compatible versions for Flask, Werkzeug, Flask-SQLAlchemy, and SQLAlchemy.

4. **Created the Dockerfile**

   * Created a Dockerfile using `python:3.12-alpine` image.
   * Set `/app` as the working directory.
   * Copied the application files into the container.
   * Installed Python dependencies.
   * Set the container to run as a non-root user.
   * Exposed port `5000`.
   * Configured the container to start the Flask application.

5. **Configured Environment Variables**

   * Added a .env.example file containing the required environment variable and a dummy secret key as a template for other users.
   * Users can copy .env.example to .env and replace the dummy value with their own secret key before running the application. 
   * The .env file was included in the Docker build context and therefore copied into the Docker image using COPY . ..
   * This approach allowed the application to access the SECRET_KEY from inside the container.
   * For a production deployment, the recommended approach would be to exclude .env from the Docker image and inject the secret at container runtime using Docker environment variables or --env-file.

6. **Built the Docker Image**

   * Built the application image using Docker.
     ```bash
     docker built -t cafe-app .
     ```

7. **Ran the Application in Docker**

   * Started the Docker container using:
     ```bash
     docker run -d -p 5000:5000 --name cafe-app cafe-app:latest
     ```
   * Started the Docker container with port mapping from host port `5000` to container port `5000`.
   * Verified that the Flask application started successfully using ```docker ps```.

8. **Tested the Application**

   * Accessed the application through a web browser.
   * Tested application by adding cafe to confirm the working.

9. **Documented the Deployment**

  * Documented the Dockerfile and Docker commands used.
  * Documented the issues encountered and their resolutions.
  * Documented the final application structure and deployment process.

# Application Images 
  
<img width="2559" height="1536" alt="Screenshot 2026-08-23 113219" src="https://github.com/user-attachments/assets/0ad18bf7-0e77-4e85-b5f4-bc5b9df4b581" />

<img width="2555" height="1536" alt="Screenshot 2026-08-23 113321" src="https://github.com/user-attachments/assets/c3bdcef0-420e-4fe2-ab75-1a27cd2e2a71" />

<img width="2559" height="1538" alt="Screenshot 2026-08-23 113338" src="https://github.com/user-attachments/assets/cd41b2fa-3080-4f49-a7d4-05213ffba741" />

---

# Problem Faced

## Flask and Werkzeug Version Compatibility

Problem:
After building and running the Docker container, the application failed to start with the following error:

ImportError: cannot import name 'url_quote' from 'werkzeug.urls'

Cause:
The application was using an older Flask version that was incompatible with the newer version of Werkzeug installed by pip.

Solution:
Pinned Werkzeug to a compatible version in requirements.txt:

Werkzeug<3.0

The Docker image was then rebuilt.

<img width="2559" height="1555" alt="Screenshot 2026-08-22 225344" src="https://github.com/user-attachments/assets/cddfc867-a67b-4b4f-a331-12055687ab64" />

## Flask-SQLAlchemy and SQLAlchemy Version Compatibility

Problem:
After resolving the Flask/Werkzeug issue, the application failed during database initialization with:

AttributeError: module 'sqlalchemy' has no attribute '__all__'

Cause:
The application was using Flask-SQLAlchemy==2.5.1, but SQLAlchemy was not pinned. Docker therefore installed a newer SQLAlchemy version that was incompatible with the older Flask-SQLAlchemy version.

Solution:
Added a compatible SQLAlchemy version to requirements.txt:

SQLAlchemy==1.4.54

The Docker image was rebuilt to install the correct dependency versions.

<img width="2559" height="1551" alt="Screenshot 2026-08-22 230546" src="https://github.com/user-attachments/assets/86b861a3-2372-44c8-9662-b1baee194f97" />

##  Missing `.env` Configuration / Secret Key

**Problem:**
The application returned a `500 Internal Server Error` when accessing the `/add` and `/edit` routes.

The Docker logs showed:

```text
RuntimeError: A secret key is required to use CSRF.
```

**Cause:**
The application was already configured to use a `SECRET_KEY` through the environment:

```python
app.config["SECRET_KEY"] = os.getenv("SECRET_KEY")
```

However, the required `.env` configuration containing `SECRET_KEY` was not initially provided by me. This resulted in the application receiving no secret key when running in Docker.

**Solution:**
Added the required `.env` configuration with a `SECRET_KEY` so the application could run correctly inside the container.

A `.env.example` file was also added with a **dummy secret key** and the required configuration. This makes it clear to anyone using the application that a `.env` file is required and provides a template that can be copied and customized.

This also improved the project's documentation because the original project did not clearly indicate that the application required a `.env` file, which made the missing configuration easy to overlook.

<img width="2559" height="1539" alt="Screenshot 2026-08-22 233403" src="https://github.com/user-attachments/assets/798a3a98-295c-4771-b4ec-8f5da0e1aa74" />


# Assignment Outcome

The assignment was successfully completed by containerizing the Flask application and running it inside a Docker container.

The final outcome includes:

* A functional Dockerized Flask application.
* A successfully built Docker image.
* The application running inside a Docker container on port `5000`.
* Application functionality verified through a web browser.
* Dependency compatibility issues identified and resolved.
* The missing `.env` configuration requirement identified and documented.
* A `.env.example` file added with a dummy secret key to make the required configuration clear for future users.
* Docker logs used to identify and troubleshoot application-level errors.
* The complete containerization, troubleshooting, and deployment process documented in this README.

This assignment provided practical experience with **Docker, Flask application deployment, dependency management, environment variables, debugging, and container troubleshooting**.

# Acknowledgement

This project is based on following repository which I have forked :
> <https://github.com/varadhancst/Cafe-website>

All credit for original application goes to owner.
