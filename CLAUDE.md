## Project Overview

This is a Godot-based simulation game where the player manages a town set in the western genre. The game features town building, resource gathering, quest assignment to citizens, interactions with neighboring towns and communities, and overall town growth.

## Project Structure

### Resources — ./src/resource_definition

All resource definitions live here. When adding a new resource type, create its definition file in this folder.

### Common Helpers — ./src/common

Shared, reusable utilities and helper code are kept here. This code is intended to be project-agnostic — it should be clean enough to drop into another project without modification.

### Managers — ./src/managers

To keep the auto-load list manageable, a manager_controller class handles manager injection into scenes that need them. Once injected, a manager is accessible from anywhere in that scene's code. All manager implementations live in this folder.

### Screens — ./src/screens

All game screens go here. Each screen should consist of its .tscn scene file and, if needed, a companion script. Keep screen folders focused — avoid putting unrelated logic here.

### UI Components — ./src/ui

Reusable UI components are stored here, separate from screen-level logic.

### Types & Enums — ./src/types

Shared types and enums that are used across multiple systems and don't belong to any single component are defined here.

### Assets — ./assets

All static game assets (sprites, audio, fonts, etc.) belong here. Anything that ships as a raw file rather than a GDScript resource goes in this directory.