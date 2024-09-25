# 🎴 QuickSet Online

**QuickSet Online** is a real-time multiplayer card game inspired by the classic game [Set](https://en.wikipedia.org/wiki/Set_(card_game))! This project is completely open-source, and we'd love your contributions to make it even better! 🃏

🎮 **Live Demo**: [Play Now!](https://quickset.online)

![Game Screenshot](url-of-game-screenshot)

## ✨ Features

- 🕹️ Real-time multiplayer with friends or random opponents.
- 🎨 Clean, responsive UI inspired by the original Set game.
- 🔄 Automatic state synchronization for seamless gameplay.
- 🧑‍💻 Built using [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) and [Elixir](https://elixir-lang.org).

## 🚀 Getting Started

Follow these instructions to set up the project locally.

### Prerequisites

- [Elixir](https://elixir-lang.org/install.html)
- [Phoenix Framework](https://hexdocs.pm/phoenix/installation.html)
- [PostgreSQL](https://www.postgresql.org/download/)

### Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/quickset.online.git
    cd quickset.online
    ```

2. **Install dependencies**:
    ```bash
    mix deps.get
    npm install --prefix assets
    ```

3. **Set up the database**:
    ```bash
    mix ecto.setup
    ```

4. **Start the Phoenix server**:
    ```bash
    mix phx.server
    ```

5. Visit `http://localhost:4000` to play locally.

## 🛠️ Tech Stack

- **Backend**: Phoenix LiveView, Elixir
- **Frontend**: Tailwind CSS, JavaScript
- **Database**: PostgreSQL

## 🧩 How to Play

1. Players join the game via a shared URL.
2. Select 3 cards that form a valid "Set".
3. The first player to collect the most Sets wins!

For a full breakdown of the game rules, see the [Set card game Wikipedia page](https://en.wikipedia.org/wiki/Set_(card_game)).

## 🖌️ Contributing

We ❤️ contributions! If you'd like to contribute to the project, follow these steps:

1. **Fork** this repository.
2. **Create** a new branch (`git checkout -b feature/your-feature-name`).
3. **Commit** your changes (`git commit -m 'Add new feature'`).
4. **Push** your branch (`git push origin feature/your-feature-name`).
5. Open a **pull request** and we'll review it as soon as possible!

## 🐛 Issues & Feedback

If you encounter any bugs 🐞 or have suggestions for improvements 💡, feel free to [open an issue](https://github.com/yourusername/quickset.online/issues).
