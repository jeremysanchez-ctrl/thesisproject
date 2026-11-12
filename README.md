# 🎓 DCS-SFMS — Department of Computer Studies Stakeholder Feedback Management System

A full-stack web application built for **Cavite State University — Imus Campus**, Department of Computer Studies. It digitizes the official HRDO-QF-07 paper feedback form and provides a complete suite of tools for managing stakeholder responses, generating reports, and controlling system access.

---

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Prerequisites](#-prerequisites)
- [Installation & Setup](#-installation--setup)
- [Running the Application](#-running-the-application)
- [Default Login Credentials](#-default-login-credentials)
- [Project Structure](#-project-structure)
- [Environment Variables](#-environment-variables)
- [Available Scripts](#-available-scripts)
- [How to Use](#-how-to-use)

---

## ✨ Features

| Feature | Description |
|---|---|
| **QR Code Generation** | Auto-generates scannable QR codes for events. Detects local LAN IP so mobile phones on the same Wi-Fi can scan and access the form instantly. |
| **Mobile-Responsive Survey Form** | The HRDO-QF-07 feedback form is fully responsive and adapts to any screen size (desktop, tablet, mobile). |
| **Event & Form Management** | Create events, build feedback forms with questions, activate/deactivate/archive forms. |
| **Response Collection** | Respondents submit via QR scan. All data is saved with a unique Control Number. |
| **Summary Report (PDF/Excel)** | Generates a harmonized CSM-style summary report with satisfaction statistics, demographic breakdown, and official signature block. |
| **Detailed Response Report (PDF)** | Replicates the physical paper form layout for each individual respondent, with checkmarks in the selected answer slots. |
| **User Account Management** | Super Admins can create, update, activate/deactivate, and delete admin accounts. |
| **Report Approval Workflow** | Admins request report generation; Super Admins approve or decline. |
| **Audit Activity Log** | Full log of all user actions — logins, form changes, report generation, and more. |
| **Archive & Safety Bin** | Forms and QR codes can be archived (soft-delete) and permanently deleted from an archive bin. |
| **System Control (Super Admin)** | Remote server shutdown directly from the admin panel. |

---

## 🛠 Tech Stack

- **Framework:** [Next.js 16](https://nextjs.org/) (App Router with Turbopack)
- **Runtime:** [Node.js v20+](https://nodejs.org/)
- **Language:** TypeScript
- **Database:** SQLite (via [Prisma ORM v5](https://www.prisma.io/))
- **Authentication:** Custom session-based auth using hashed cookies
- **PDF Generation:** [jsPDF](https://github.com/parallax/jsPDF) + [jspdf-autotable](https://github.com/simonbengtsson/jsPDF-AutoTable)
- **Excel Generation:** [SheetJS (xlsx)](https://sheetjs.com/)
- **QR Codes:** [qrcode](https://github.com/soldair/node-qrcode)
- **Charts:** [Chart.js](https://www.chartjs.org/) + [react-chartjs-2](https://react-chartjs-2.js.org/)
- **Styling:** Vanilla CSS (no Tailwind — inline styles + media queries)

---

## ⚙️ Prerequisites

Before you begin, make sure you have the following installed:

| Tool | Version | Download |
|---|---|---|
| **Node.js** | v20 or higher | https://nodejs.org/ |
| **npm** | v10 or higher (comes with Node.js) | Included with Node.js |
| **Git** | Any recent version | https://git-scm.com/ |

To verify your installations, open a terminal and run:
```bash
node -v    # Should show v20.x.x or higher
npm -v     # Should show 10.x.x or higher
git -v     # Should show git version x.x.x
```

---

## 🚀 Installation & Setup

### Step 1 — Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/DCS-SFMS.git
cd DCS-SFMS
```

### Step 2 — Install Dependencies

```bash
npm install
```

> This will install all required packages including Next.js, Prisma, jsPDF, qrcode, and others. It may take 1–2 minutes.

### Step 3 — Set Up Environment Variables

Copy the example environment file and edit it:

```bash
# On Windows (Command Prompt)
copy .env.example .env

# On Windows (PowerShell) / macOS / Linux
cp .env.example .env
```

Now open `.env` in any text editor and fill in the values:

```env
# Database — leave as-is for local SQLite setup
DATABASE_URL="file:./prisma/dev.db"

# Session secret — change this to any long random string for security
SESSION_SECRET="your-very-long-random-secret-key-here-change-this"

# Optional: Public URL for QR codes (leave blank for automatic LAN IP detection)
NEXT_PUBLIC_APP_URL=""
```

> ⚠️ **IMPORTANT:** Never commit your `.env` file to GitHub. It is already excluded in `.gitignore`.

### Step 4 — Initialize the Database

Run Prisma to create the SQLite database and apply the schema:

```bash
npx prisma db push
```

Then seed the database with initial data (default users, stakeholder categories, and a sample form):

```bash
npx tsx prisma/seed.ts
```

> This creates the default admin accounts and the initial HRDO-QF-07 feedback form.

### Step 5 — Generate Prisma Client

```bash
npx prisma generate
```

---

## ▶️ Running the Application

### Development Mode (Recommended for local testing)

```bash
npm run dev
```

The application will start at:
- **Local:** http://localhost:3000
- **Network (for mobile scanning):** http://[your-local-ip]:3000

The terminal will display your network address. Use this address in the QR Code configurator so mobile phones on the same Wi-Fi can scan and access the survey.

### Production Mode

```bash
# Build first
npm run build

# Then start
npm run start
```

---

## 🔑 Default Login Credentials

After seeding, log in at **http://localhost:3000/admin/login** using:

| Role | Email | Password |
|---|---|---|
| **Super Admin** | `admin@sfms.local` | `password123` |
| **Regular Admin** | `regadmin@sfms.local` | `password123` |
| **Department Head** | `depthead@sfms.local` | `password123` |
| **QA Officer** | `qa@sfms.local` | `password123` |

> ⚠️ **Change all passwords immediately after first login in a production environment.**

---

## 📁 Project Structure

```
DCS-SFMS/
├── prisma/
│   ├── schema.prisma       # Database schema (models and relationships)
│   └── seed.ts             # Database seeder (initial users, categories, forms)
├── public/                 # Static assets (images, icons)
├── src/
│   ├── app/
│   │   ├── admin/          # Admin dashboard pages (protected routes)
│   │   │   ├── (protected)/
│   │   │   │   ├── dashboard/        # Overview statistics
│   │   │   │   ├── forms/            # Form builder & management
│   │   │   │   ├── qr-codes/         # QR code generation
│   │   │   │   ├── reports/          # PDF & Excel report downloads
│   │   │   │   ├── report-requests/  # Approval workflow
│   │   │   │   ├── users/            # User account management
│   │   │   │   ├── archive/          # Archived forms & safety bin
│   │   │   │   ├── activity-log/     # Audit trail
│   │   │   │   └── system-control/   # Remote server control (Super Admin)
│   │   │   └── login/                # Admin login page
│   │   ├── api/            # REST API endpoints
│   │   │   ├── admin/      # Admin management APIs
│   │   │   ├── auth/       # Login & logout
│   │   │   ├── qr-codes/   # QR image generation
│   │   │   └── reports/    # PDF & Excel generation
│   │   ├── form/           # Public survey form (respondent-facing)
│   │   │   └── [formId]/   # Dynamic route per active form
│   │   └── q/              # QR redirect handler
│   │       └── [codeString]/
│   ├── components/         # Shared UI components
│   └── lib/                # Utilities: auth, Prisma client, security, URL helper
├── .env.example            # Template for environment variables
├── .gitignore              # Git ignore rules
├── next.config.ts          # Next.js configuration
├── package.json            # Project metadata and scripts
├── prisma.config.ts        # Prisma configuration
└── tsconfig.json           # TypeScript configuration
```

---

## 🌐 Environment Variables

| Variable | Required | Description |
|---|---|---|
| `DATABASE_URL` | ✅ Yes | Path to SQLite database file. Use `file:./prisma/dev.db` for local. |
| `SESSION_SECRET` | ✅ Yes | A long random string used to sign session cookies. Change for production. |
| `NEXT_PUBLIC_APP_URL` | ❌ Optional | Override the base URL embedded in QR codes. Leave blank to auto-detect LAN IP. |

---

## 📦 Available Scripts

| Command | Description |
|---|---|
| `npm run dev` | Start the development server with hot reload |
| `npm run build` | Build the application for production |
| `npm run start` | Start the production server (after building) |
| `npm run lint` | Run ESLint to check for code errors |
| `npx tsx prisma/seed.ts` | Seed the database with initial demo data |
| `npx prisma db push` | Push schema changes to the database |
| `npx prisma generate` | Regenerate Prisma client after schema changes |
| `npx prisma studio` | Open the Prisma Studio database GUI in browser |

---

## 📱 How to Use

### For Administrators

1. Open **http://localhost:3000/admin/login** and log in.
2. Go to **Forms** → Create a new feedback form and set it to **Active**.
3. Go to **QR Access** → Select the event and click **Generate Event QR Code**.
4. Download the QR code PNG and print/display it at the venue.
5. Respondents scan the QR code with their mobile phone and fill out the form.
6. View submitted responses under **Reports** and download PDF/Excel.

### For Respondents (Mobile Phone Users)

1. Make sure your phone is connected to the **same Wi-Fi network** as the server.
2. Scan the QR code displayed at the venue using your phone camera.
3. Fill out the form and tap **Submit Stakeholder Feedback**.
4. You will receive a unique **Control Number** confirming your submission.

### For System Control (Super Admin Only)

- To shut down remotely: **Admin Panel → ⚙️ System Control → Shut Down Server**.
- To restart: Run `npm run dev` on the host machine's terminal.

---

## 🔒 Security Notes

- All passwords are hashed using **scrypt** (Node.js native crypto) — never stored in plain text.
- Sessions are stored as signed HTTP-only cookies.
- Admin routes are protected by server-side role checks on every request.
- The `.env` file and SQLite database are excluded from version control via `.gitignore`.
- For production deployment, always use a strong, randomly generated `SESSION_SECRET`.

---

## 📄 License

This project was developed for the **Department of Computer Studies, Cavite State University — Imus Campus**.

For inquiries, contact the Department Chair: **Grace S. Ibañez**

---

*Built with Next.js 16, Prisma ORM, and SQLite. Designed for local network deployment.*
