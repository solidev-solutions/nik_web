module.exports = {
	parserPreset: "conventional-changelog-conventionalcommits",
	// By default commitlint lets titles such as "Revert ..." or "Merged ..." pass unchecked.
	defaultIgnores: false,
	rules: {
		"subject-empty": [2, "never"],
		"type-case": [2, "always", "lower-case"],
		"type-empty": [2, "never"],
		"type-enum": [
			2,
			"always",
			[
				"build",
				"chore",
				"ci",
				"docs",
				"feat",
				"fix",
				"perf",
				"refactor",
				"revert",
				"style",
				"test",
			],
		],
	},
};
