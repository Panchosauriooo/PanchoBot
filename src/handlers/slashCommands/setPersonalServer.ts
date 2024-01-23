import { EmbedBuilder, SlashCommandBuilder } from "discord.js";
import { SlashCommand } from "../../interfaces";
import { db } from "../../db";
import { logger } from "../../utils";

export const setPersonalServer: SlashCommand = {
	data: new SlashCommandBuilder()
		.setName("set-personal-server")
		.setDescription("Set the current server as your personal server.")
		.setDMPermission(false),
	execute: async (interaction) => {
		await interaction.deferReply();

		if (interaction.guild.ownerId !== interaction.user.id) {
			logger.error({
				type: "slash-command",
				commandName: interaction.commandName,
				userId: interaction.user.id,
				guildId: interaction.guild.id,
				message:
					"failed to set personal server: user is not the owner of the server",
			});

			await interaction.editReply({
				embeds: [
					new EmbedBuilder()
						.setColor("Red")
						.setTitle("Error")
						.setDescription(
							"You must be the owner of the server in order to set it as your personal server.",
						),
				],
			});

			return;
		}

		try {
			await db.user.upsert({
				where: {
					discord_id: interaction.user.id,
				},
				create: {
					discord_id: interaction.user.id,
					personal_server_id: interaction.guild.id,
				},
				update: {
					personal_server_id: interaction.guild.id,
				},
			});
		} catch (error) {
			logger.error({
				type: "slash-command",
				commandName: interaction.commandName,
				userId: interaction.user.id,
				guildId: interaction.guild.id,
				message: `failed to set personal server: ${error}`,
			});

			await interaction.editReply({
				embeds: [
					new EmbedBuilder()
						.setColor("Red")
						.setTitle("Error")
						.setDescription(
							"An error ocurred while trying to set your personal server. Please try again later.",
						),
				],
			});

			return;
		}

		logger.info({
			type: "slash-command",
			commandName: interaction.commandName,
			userId: interaction.user.id,
			guildId: interaction.guild.id,
			message: `set personal server to ${interaction.guild.id}`,
		});

		await interaction.editReply({
			embeds: [
				new EmbedBuilder()
					.setColor("Green")
					.setTitle("Success")
					.setDescription(
						"The current server has been set as your personal server.",
					),
			],
		});
	},
};
