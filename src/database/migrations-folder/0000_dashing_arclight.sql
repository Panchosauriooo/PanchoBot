CREATE TABLE `lobbies_to_teams` (
	`lobby_id` bigint NOT NULL,
	`team_id` bigint NOT NULL,
	`created_at` timestamp DEFAULT (now()),
	`updated_at` timestamp ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE `users_to_teams` (
	`user_id` bigint NOT NULL,
	`team_id` bigint NOT NULL,
	`created_at` timestamp DEFAULT (now()),
	`updated_at` timestamp ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE `lobbies` (
	`id` bigint AUTO_INCREMENT PRIMARY KEY NOT NULL,
	`tournament_id` bigint NOT NULL,
	`named_id` varchar(16),
	`schedule` date,
	`status` enum('pending','done') DEFAULT 'pending',
	`stage` enum('groups','qualifiers','round_64','round_32','round_16','quarterfinals','semifinals','finals','grandfinals') NOT NULL,
	`mp_link` varchar(256),
	`created_at` timestamp DEFAULT (now()),
	`updated_at` timestamp ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE `teams` (
	`id` bigint AUTO_INCREMENT PRIMARY KEY NOT NULL,
	`name` varchar(64),
	`preferred_timezone` enum('-12UTC','-11UTC','-10UTC','-9UTC','-8UTC','-7UTC','-6UTC','-5UTC','-4UTC','-3UTC','-2UTC','-1UTC','0UTC','1UTC','2UTC','3UTC','4UTC','5UTC','6UTC','7UTC','8UTC','9UTC','10UTC','11UTC','12UTC') NOT NULL,
	`captain_id` bigint,
	`created_at` timestamp DEFAULT (now()),
	`updated_at` timestamp ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE `tournaments` (
	`id` bigint PRIMARY KEY NOT NULL,
	`name` varchar(64) NOT NULL,
	`acronym` varchar(8) NOT NULL,
	`server_id` bigint NOT NULL,
	`schedules_channel_id` bigint NOT NULL,
	`creator_id` bigint NOT NULL,
	`win_condition` enum('score','acc','misses') DEFAULT 'score',
	`scoring` enum('v1','v2','lazer') NOT NULL DEFAULT 'v2',
	`player_role_id` bigint NOT NULL,
	`referee_role_id` bigint NOT NULL,
	`type` enum('team_based','one_vs_one','battle_royale'),
	`created_at` timestamp DEFAULT (now())
);

CREATE TABLE `users` (
	`discord_id` bigint PRIMARY KEY NOT NULL,
	`user_id` int,
	`username` varchar(32),
	`created_at` timestamp DEFAULT (now()),
	`updated_at` timestamp ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE lobbies_to_teams ADD CONSTRAINT lobbies_to_teams_lobby_id_lobbies_id_fk FOREIGN KEY (`lobby_id`) REFERENCES lobbies(`id`) ON DELETE no action ON UPDATE cascade;
ALTER TABLE lobbies_to_teams ADD CONSTRAINT lobbies_to_teams_team_id_teams_id_fk FOREIGN KEY (`team_id`) REFERENCES teams(`id`) ON DELETE no action ON UPDATE cascade;
ALTER TABLE users_to_teams ADD CONSTRAINT users_to_teams_user_id_users_discord_id_fk FOREIGN KEY (`user_id`) REFERENCES users(`discord_id`) ON DELETE no action ON UPDATE cascade;
ALTER TABLE users_to_teams ADD CONSTRAINT users_to_teams_team_id_teams_id_fk FOREIGN KEY (`team_id`) REFERENCES teams(`id`) ON DELETE no action ON UPDATE cascade;
ALTER TABLE lobbies ADD CONSTRAINT lobbies_tournament_id_tournaments_id_fk FOREIGN KEY (`tournament_id`) REFERENCES tournaments(`id`) ON DELETE no action ON UPDATE cascade;
ALTER TABLE teams ADD CONSTRAINT teams_captain_id_users_discord_id_fk FOREIGN KEY (`captain_id`) REFERENCES users(`discord_id`) ON DELETE no action ON UPDATE cascade;
ALTER TABLE tournaments ADD CONSTRAINT tournaments_creator_id_users_discord_id_fk FOREIGN KEY (`creator_id`) REFERENCES users(`discord_id`) ON DELETE no action ON UPDATE cascade;