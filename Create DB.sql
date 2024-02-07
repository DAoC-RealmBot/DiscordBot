USE [master]
GO
/****** Object:  Database [daoctracking]    Script Date: 2/7/2024 2:08:12 PM ******/
CREATE DATABASE [daoctracking]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'daoctracking', FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\daoctracking.mdf' , SIZE = 2170880KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 FILEGROUP [RealmPointsArchived] 
( NAME = N'RealmPointsArchived', FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\RealmPointsArchived.mdf' , SIZE = 30720KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [RealmPointsRecent] 
( NAME = N'RealmPointsRecent', FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\RealmPointsRecent.mdf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'daoctracking_log', FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\daoctracking_log.ldf' , SIZE = 8069120KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [daoctracking] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [daoctracking].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [daoctracking] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [daoctracking] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [daoctracking] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [daoctracking] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [daoctracking] SET ARITHABORT OFF 
GO
ALTER DATABASE [daoctracking] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [daoctracking] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [daoctracking] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [daoctracking] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [daoctracking] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [daoctracking] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [daoctracking] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [daoctracking] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [daoctracking] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [daoctracking] SET  DISABLE_BROKER 
GO
ALTER DATABASE [daoctracking] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [daoctracking] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [daoctracking] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [daoctracking] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [daoctracking] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [daoctracking] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [daoctracking] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [daoctracking] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [daoctracking] SET  MULTI_USER 
GO
ALTER DATABASE [daoctracking] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [daoctracking] SET DB_CHAINING OFF 
GO
ALTER DATABASE [daoctracking] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [daoctracking] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [daoctracking] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [daoctracking] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'daoctracking', N'ON'
GO
ALTER DATABASE [daoctracking] SET QUERY_STORE = ON
GO
ALTER DATABASE [daoctracking] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [daoctracking]
GO
/****** Object:  User [RealmBotSvc]    Script Date: 2/7/2024 2:08:12 PM ******/
CREATE USER [RealmBotSvc] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NT SERVICE\SQLSERVERAGENT]    Script Date: 2/7/2024 2:08:12 PM ******/
CREATE USER [NT SERVICE\SQLSERVERAGENT] FOR LOGIN [NT SERVICE\SQLSERVERAGENT] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [RealmBotSvc]
GO
ALTER ROLE [db_owner] ADD MEMBER [NT SERVICE\SQLSERVERAGENT]
GO
/****** Object:  Table [dbo].[announcements]    Script Date: 2/7/2024 2:08:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[announcements](
	[announcementkey] [int] IDENTITY(1,1) NOT NULL,
	[announcementtext] [varchar](4000) NULL,
	[announcementtype] [varchar](100) NULL,
	[announcementtime] [time](7) NULL,
	[channelID] [bigint] NULL,
	[mentionID] [varchar](100) NULL,
	[channelname] [varchar](100) NULL,
	[mentionname] [varchar](100) NULL,
 CONSTRAINT [PK__announce__C7DA605F16E2E37E] PRIMARY KEY CLUSTERED 
(
	[announcementkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bloblogging]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bloblogging](
	[blobtrackingkey] [int] IDENTITY(1,1) NOT NULL,
	[blob] [nvarchar](max) NULL,
	[secondblob] [nvarchar](max) NULL,
	[timestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_bloblogging] PRIMARY KEY CLUSTERED 
(
	[blobtrackingkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[characterrealmstats]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[characterrealmstats](
	[characterrealmstatskey] [int] IDENTITY(1,1) NOT NULL,
	[character_web_id] [varchar](400) NULL,
	[realmpoints] [int] NULL,
	[bountpoints] [int] NULL,
	[totalkills] [int] NULL,
	[totaldeaths] [int] NULL,
	[totaldeathblows] [int] NULL,
	[totalsolokills] [int] NULL,
	[midkills] [int] NULL,
	[middeathblows] [int] NULL,
	[midsolokills] [int] NULL,
	[hibkills] [int] NULL,
	[hibdeathblows] [int] NULL,
	[hibsolokills] [int] NULL,
	[albkills] [int] NULL,
	[albdeathblows] [int] NULL,
	[albsolokills] [int] NULL,
	[importdate] [date] NULL,
	[lifetimeIRS]  AS (case when [totaldeaths]=(0) then [realmpoints] else [realmpoints]/CONVERT([decimal](15,2),[totaldeaths]) end),
	[dailyrealmpoints] [int] NULL,
	[dailydeaths] [int] NULL,
	[dailyIRS]  AS (case when [dailydeaths]=(0) then [dailyrealmpoints] else [dailyrealmpoints]/CONVERT([decimal](15,2),[dailydeaths]) end),
	[lastrecordflag] [int] NULL,
 CONSTRAINT [PK_characterrealmstats] PRIMARY KEY CLUSTERED 
(
	[characterrealmstatskey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[characters]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[characters](
	[characterskey] [int] IDENTITY(1,1) NOT NULL,
	[character_web_id] [nvarchar](200) NULL,
	[name] [nvarchar](4000) NULL,
	[firstname] [nvarchar](4000) NULL,
	[server_name] [nvarchar](4000) NULL,
	[archived] [nvarchar](4000) NULL,
	[realm] [int] NULL,
	[race] [nvarchar](4000) NULL,
	[class_name] [nvarchar](4000) NULL,
	[level] [int] NULL,
	[last_on_range] [int] NOT NULL,
	[realm_points] [int] NULL,
	[guild_rank] [int] NULL,
	[guild_web_id] [nvarchar](100) NULL,
	[watchlistflag] [bit] NOT NULL,
	[lastupdated] [datetime] NULL,
 CONSTRAINT [PK_characters] PRIMARY KEY CLUSTERED 
(
	[characterskey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[commands]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[commands](
	[commandskey] [int] IDENTITY(1,1) NOT NULL,
	[commandtext] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[commandskey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[guilds]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[guilds](
	[guildskey] [int] IDENTITY(1,1) NOT NULL,
	[guild_web_id] [varchar](100) NULL,
	[guildname] [varchar](2000) NULL,
	[importedflag] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[guildskey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[guilds_importedfalse]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[guilds_importedfalse](
	[guildskey] [int] IDENTITY(1,1) NOT NULL,
	[guild_web_id] [varchar](100) NULL,
	[guildname] [varchar](2000) NULL,
	[importedflag] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[realmranks]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[realmranks](
	[realmrankskey] [int] IDENTITY(1,1) NOT NULL,
	[realmrank] [varchar](10) NULL,
	[realmpoints] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[realmrankskey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [nvarchar](80) NOT NULL,
	[email] [nvarchar](120) NOT NULL,
	[password_hash] [nvarchar](120) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserCharacterXref]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserCharacterXref](
	[usercharacterxrefkey] [int] IDENTITY(1,1) NOT NULL,
	[character_web_id] [nvarchar](200) NOT NULL,
	[userid] [int] NULL,
 CONSTRAINT [PK__UserChar__900A98A8B6831A4B] PRIMARY KEY CLUSTERED 
(
	[usercharacterxrefkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NC_character_web_id]    Script Date: 2/7/2024 2:08:13 PM ******/
CREATE NONCLUSTERED INDEX [NC_character_web_id] ON [dbo].[characterrealmstats]
(
	[character_web_id] ASC
)
INCLUDE([characterrealmstatskey],[importdate],[dailyrealmpoints],[dailydeaths]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NC_Character_web_id_filtered]    Script Date: 2/7/2024 2:08:13 PM ******/
CREATE NONCLUSTERED INDEX [NC_Character_web_id_filtered] ON [dbo].[characterrealmstats]
(
	[character_web_id] ASC,
	[importdate] ASC
)
INCLUDE([lifetimeIRS],[dailyIRS]) 
WHERE ([lastrecordflag]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NC_character_web_id]    Script Date: 2/7/2024 2:08:13 PM ******/
CREATE NONCLUSTERED INDEX [NC_character_web_id] ON [dbo].[characters]
(
	[character_web_id] ASC,
	[name] ASC
)
INCLUDE([characterskey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NC_Guild_web_id]    Script Date: 2/7/2024 2:08:13 PM ******/
CREATE NONCLUSTERED INDEX [NC_Guild_web_id] ON [dbo].[characters]
(
	[guild_web_id] ASC
)
INCLUDE([character_web_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NC_guild_web_id]    Script Date: 2/7/2024 2:08:13 PM ******/
CREATE NONCLUSTERED INDEX [NC_guild_web_id] ON [dbo].[guilds]
(
	[guild_web_id] ASC
)
INCLUDE([guildskey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bloblogging] ADD  CONSTRAINT [DF_bloblogging_timestamp]  DEFAULT (getdate()) FOR [timestamp]
GO
ALTER TABLE [dbo].[characters] ADD  CONSTRAINT [DF_characters_watchlistflag]  DEFAULT ((0)) FOR [watchlistflag]
GO
/****** Object:  StoredProcedure [dbo].[ASyncStoredProcCall]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 CREATE PROCEDURE [dbo].[ASyncStoredProcCall] 
    @command varchar(max)
AS

 
 declare @job varchar(1000) = concat(@command,' ', newid())

 print @job
 print @command

exec msdb..sp_add_job
@job_name =@job,
@enabled=1,
@start_step_id=1,
@delete_level=3 --Job will delete itself after success

exec msdb..sp_add_jobstep
@job_name=@job,
@step_id=1,
@step_name='step1',
@command=@command,
@database_name = 'daoctracking'
exec msdb..sp_add_jobserver
@job_name = @job

exec msdb..sp_start_job
@job_name=@job

RETURN 0 
GO
/****** Object:  StoredProcedure [dbo].[CreateCharacter]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[CreateCharacter]
	@character_web_id NVARCHAR(MAX), 
	@name NVARCHAR(MAX), 
	@firstname NVARCHAR(MAX), 
	@server_name NVARCHAR(MAX), 
	@archived NVARCHAR(MAX), 
	@realm NVARCHAR(MAX), 
	@race NVARCHAR(MAX), 
	@class_name NVARCHAR(MAX), 
	@level NVARCHAR(MAX), 
	@last_on_range NVARCHAR(MAX), 
	@realm_points NVARCHAR(MAX), 
	@guild_rank NVARCHAR(MAX), 
	@guild_web_id NVARCHAR(MAX),
	@watchlistflag int
AS
BEGIN

insert into characters
select @character_web_id, @name, @firstname, @server_name, @archived, @realm, @race, @class_name, @level, @last_on_range, @realm_points, @guild_rank, @guild_web_id,@watchlistflag, null
where not exists
(
	select *
	from characters
	where character_web_id = @character_web_id
)

END
GO
/****** Object:  StoredProcedure [dbo].[CreateCharacterLink]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateCharacterLink]
    @json_data NVARCHAR(MAX)
AS
BEGIN

    -- Parse the JSON data
    DECLARE @JsonTable TABLE (character_web_id nvarchar(200), userid INT)
    INSERT INTO @JsonTable
    SELECT * FROM OPENJSON(@json_data,'$')
	with
		(
			character_web_id varchar(4000),
			userid int
		)
	
    -- Process the data (insert, update, etc.) in @JsonTable
    -- For example, insert records into a table
    INSERT INTO UserCharacterXref (character_web_id, userid)
    SELECT character_web_id, userid
    FROM @JsonTable jt
	where not exists
	(
		select *
		from UserCharacterXref uc
		where jt.character_web_id = uc.character_web_id
		and jt.userid = uc.userid
	)
END
GO
/****** Object:  StoredProcedure [dbo].[CreateGuild]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[CreateGuild]
    @guild_web_id NVARCHAR(MAX),
	@guildname NVARCHAR(MAX),
	@importedflag int
AS
BEGIN

insert into guilds
select @guild_web_id, @guildname, @importedflag

where not exists
(
	select *
	from guilds
	where guild_web_id = @guild_web_id
)

END
GO
/****** Object:  StoredProcedure [dbo].[FindActiveCharacters]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FindActiveCharacters]

AS
	declare 

		@url varchar(4000),
		@charid varchar(200),
		@laston as int,
		@Object as Int,
		@ResponseText as Varchar(max)

	DECLARE char_cursor CURSOR
	FOR 
	select character_web_id
	from characters

	OPEN char_cursor
	FETCH NEXT FROM char_cursor
	INTO @charid

	WHILE @@FETCH_STATUS = 0
	BEGIN


		set @Object = null
		set @ResponseText = null

		drop table if exists #tempresponse
		create table #tempresponse (response nvarchar(max))
		set @url = concat('https://api.camelotherald.com/character/info/',@charid)


		Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
		Exec sp_OAMethod @Object, 'open', NULL, 'get',
			   @URL,
			   'False'
		Exec sp_OAMethod @Object, 'send'
		insert into #tempresponse
		Exec sp_OAMethod @Object, 'responseText'
		select @ResponseText = response from #tempresponse

		select @laston = last_on_range
		from openjson(@ResponseText)
		with (
	
			last_on_range int
		)

		if @laston is not null
		begin

			update characters
			set last_on_range = @laston,
				lastupdated = getdate()
			where character_web_id = @charid
		end


	exec sp_OADestroy @Object

	FETCH NEXT FROM char_cursor
	INTO @charid
	END
	CLOSE char_cursor
	DEALLOCATE char_cursor	
	

RETURN 0 
GO
/****** Object:  StoredProcedure [dbo].[GetAnnouncements]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAnnouncements] 
AS

select *
from announcements
where announcementtype = 'Daily'
and cast(getdate()as time) between announcementtime and dateadd(minute,1,announcementtime)
    
RETURN 0 
GO
/****** Object:  StoredProcedure [dbo].[GetCharacterInfo]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [dbo].[GetCharacterInfo] 
    @charname varchar(1000)
AS
SET NOCOUNT ON

/*
Make API Call
*/	
declare @url varchar(max), 
@string varchar(max),
@line1 varchar(1000),
@line2 varchar(1000),
@line3 varchar(1000),
@line4 varchar(1000),
@line5 varchar(1000),
@line6 varchar(1000),
@line7 varchar(1000),
@line8 varchar(1000),
@guildid varchar(4000),
@charid varchar(4000)

drop table if exists #tempresponse
create table #tempresponse (response varchar(max))
		set @url = concat('https://api.camelotherald.com/character/search?cluster=Ywain&name=',@charname)

		Declare @Object as Int;
		Declare @ResponseText as Varchar(8000);

		Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
		Exec sp_OAMethod @Object, 'open', NULL, 'get',
			   @URL,
			   'False'
		Exec sp_OAMethod @Object, 'send'
		insert into #tempresponse
		Exec sp_OAMethod @Object, 'responseText'--, @ResponseText OUTPUT
		select @ResponseText = response from #tempresponse

		select top 1
		@charid = character_web_id,
		@charname = name,
		@line1 = concat('Name: ', name),
		@line2 = concat('Race: ', race),
		@line3 = concat('Class: ', class_name),
		@line4 = concat('Level: ', level),
		@line5 = concat('Realm Rank: ', rr.realmrank),
		@line6 = isnull(case 
			when guild_rank != 0 
				then concat('Rank ', guild_rank, ' member of ', guild_name)
				else 'Guild Master of ' + guild_name
			end,'Unguilded'),
		@guildid = guild_web_id
		from openjson(@ResponseText, '$.results')
		with
		(
			character_web_id varchar(4000),
			name varchar(4000),
			race varchar(4000),
			class_name varchar(4000),
			level int,
			realm_points int,
			guild_info nvarchar(max) as json
		)
		outer apply openjson (guild_info) with (guild_name varchar(4000), guild_rank int, guild_web_id varchar(4000))
		cross apply
		(
			select top 1 *
			from realmranks rr
			where realmpoints < realm_points or realmpoints = realm_points
			order by realmpoints desc
		) rr


	select 
		@line7 = concat('Lifetime IRS: ', cast(rs.lifetimeIRS as decimal(15,2))),
		@line8 = concat('Daily IRS: ', cast(rs.dailyIRS as decimal(15,2)))

	--select rs.lifetimeIRS, rs.dailyIRS
	from characters c
	join characterrealmstats rs
	on rs.character_web_id  = c.character_web_id
	and rs.lastrecordflag = 1

	where name = @charname
	print @charid
	exec ImportACharacter @charid
	
	if (select count(*) from guilds g where g.guild_web_id = @guildid) = 0
	begin
	declare @command varchar(max) 
		exec ImportGuild @guildid
		set @command = concat('exec ImportAllianceGuild ''', @guildid, '''')
		exec ASyncStoredProcCall @command
	end
	

		drop table if exists #tempresults
		create table #tempresults(results varchar(max))
		insert into #tempresults select @line1
		insert into #tempresults select @line2
		insert into #tempresults select @line3
		insert into #tempresults select @line4
		insert into #tempresults select @line5
		insert into #tempresults select @line6
		insert into #tempresults select @line7
		insert into #tempresults select @line8

		select * from #tempresults

return


GO
/****** Object:  StoredProcedure [dbo].[GetNextRealmDing]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetNextRealmDing] 
    @charname varchar(400),
    @realmrank  varchar(10) = null,
	@reportrun	bit = 0,
	@txt varchar(4000) = null output
AS
SET NOCOUNT ON
	declare @url varchar(500),
			@realmpoints int,
			@fullname varchar(4000)



	/*
	Make API Call

	*/
	drop table if exists #tempresponse
		create table #tempresponse (response varchar(max))
		set @url = concat('https://api.camelotherald.com/character/search?cluster=Ywain&name=',@charname)

		Declare @Object as Int;
		Declare @ResponseText as Varchar(8000);

		Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
		Exec sp_OAMethod @Object, 'open', NULL, 'get',
			   @URL,
			   'False'
		Exec sp_OAMethod @Object, 'send'
		insert into #tempresponse
		Exec sp_OAMethod @Object, 'responseText'--, @ResponseText OUTPUT
		select @ResponseText = response from #tempresponse

		select top 1
			@realmpoints = realm_points,
			@fullname = name
		from openjson(@ResponseText, '$.results')
		with
		(
			name varchar(4000),
			realm_points int
		)
		

	if @realmrank is null
	begin
		select top 1 @realmrank = r.realmrank		
		from realmranks r
		where r.realmpoints > @realmpoints
		order by r.realmpoints 

	end



select @txt=  concat(@fullname, ' needs ', format(b.realmpoints - @realmpoints,'#,##0'), ' realm points for ', @realmrank)  --as rpsneeded
from realmranks b
where b.realmrank = @realmrank
if @reportrun = 0
begin
	select @txt  as rpsneeded
end

RETURN 
GO
/****** Object:  StoredProcedure [dbo].[ImportACharacter]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ImportACharacter]
     @charid varchar(100)
AS

if (select count(*) from characters where character_web_id =  @charid) > 0
begin

	return 0
end

drop table if exists #CharactersImport
drop table if exists #tempresponse
create table #tempresponse (response varchar(max))

declare @URL NVARCHAR(MAX) = concat('https://api.camelotherald.com/character/info/',@charid )


Declare @Object as Int;
Declare @ResponseText as nVarchar(max);

Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
Exec sp_OAMethod @Object, 'open', NULL, 'get',
       @URL,
       'False'

Exec sp_OAMethod @Object, 'send'

insert into #tempresponse
Exec sp_OAMethod @Object, 'responseText'--, @ResponseText OUTPUT
select @ResponseText = response from #tempresponse

exec sp_OADestroy @Object


select *
into #CharactersImport
from openjson(@ResponseText,'$')
with
(
character_web_id nvarchar(4000),           
name  nvarchar(4000),     
server_name     nvarchar(4000),   
archived nvarchar(4000),
realm nvarchar(4000),
race nvarchar(4000),
class_name nvarchar(4000),
level          nvarchar(4000),
last_on_range int,
guild_info nvarchar(max) as json,
realm_war_stats nvarchar(max) as json
)
outer apply openjson (guild_info) with (guild_name varchar(4000), guild_rank int, guild_web_id varchar(4000))
outer apply openjson (realm_war_stats,'$.current') with (realm_points int)


insert into Characters
select 
	character_web_id, 
	name, 
	case 
		when charindex(' ',name) > 0
			then left(name,charindex(' ',name))
		else name
	end,
	server_name, 
	archived,
	realm,
	race,
	case 
		when class_name = 'huntress' then 'hunter'
		when class_name = 'Enchantress' then 'Enchanter'
		when class_name = 'Heroine' then 'Hero'
		when class_name = 'Sorceress' then 'Sorcerer'
		else class_name
	end,
	level,
	last_on_range, 
	realm_points, 
	guild_rank, 
	guild_web_id, 
	0 as watchlistflag,
	getdate()
from #CharactersImport a
where not exists
(
	select *
	from Characters b
	where a.character_web_id = b.character_web_id
)

RETURN 0 
GO
/****** Object:  StoredProcedure [dbo].[ImportActiveCharacterRealmStats]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportActiveCharacterRealmStats]
	@importdate date
	--@recentflag int = 1
AS
	declare 
		@realmpoints int,
		@bountpoints int,
		@totalkills int,
		@totaldeaths int,
		@totaldeathblows int,
		@totalsolokills int,
		@midkills int,
		@middeathblows int,
		@midsolokills int,
		@hibkills int,
		@hibdeathblows int,
		@hibsolokills int,
		@albkills int,
		@albdeathblows int,
		@albsolokills int,
		@url varchar(4000),
		@charid varchar(200)
			
Declare @Object as Int;
		Declare @ResponseText as Varchar(max);

	DECLARE char_cursor CURSOR
	FOR 
	select character_web_id
	from characters c
	where last_on_range not in (3,4) --Inactive --Unknown
	--or @recentflag = 0
	or not exists
	(
		select *
		from characterrealmstats crs
		where c.character_web_id = crs.character_web_id
	)

	--where character_web_id not in ('y4Vi4taHK1o','K-cHcfBGIpU','wHWCjOKr5JA')

	OPEN char_cursor
	FETCH NEXT FROM char_cursor
	INTO @charid

	WHILE @@FETCH_STATUS = 0
	BEGIN



		set @realmpoints = 0
		set @bountpoints = 0
		set @totalkills = 0
		set @totaldeaths = 0
		set @totaldeathblows = 0
		set @totalsolokills = 0
		set @midkills = 0
		set @middeathblows = 0
		set @midsolokills = 0
		set @hibkills = 0
		set @hibdeathblows = 0
		set @hibsolokills = 0
		set @albkills = 0
		set @albdeathblows = 0
		set @albsolokills = 0
		set @Object = null
		set @ResponseText = null

		drop table if exists #tempresponse
		create table #tempresponse (response varchar(max))
		set @url = concat('https://api.camelotherald.com/character/info/',@charid)


		Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
		Exec sp_OAMethod @Object, 'open', NULL, 'get',
			   @URL,
			   'False'
		Exec sp_OAMethod @Object, 'send'
		insert into #tempresponse
		Exec sp_OAMethod @Object, 'responseText'
		select @ResponseText = response from #tempresponse

		select 
			@realmpoints = realm_points,
			@bountpoints = bounty_points
		from openjson(@ResponseText, '$.realm_war_stats.current')
		with (
	
			realm_points int,
			bounty_points int
		)




		select 
		@totalkills = kills,
		@totaldeaths = deaths,
		@totaldeathblows = death_blows,
		@totalsolokills = solo_kills
		from openjson(@ResponseText, '$.realm_war_stats.current.player_kills.total')
		with (
	
			kills int,
			deaths int,
			death_blows int,
			solo_kills int
		)
		select 
			@midkills = kills,
			@middeathblows = death_blows,
			@midsolokills = solo_kills
		from openjson(@ResponseText, '$.realm_war_stats.current.player_kills.midgard')
		with (
	
			kills int,
			deaths int,
			death_blows int,
			solo_kills int
		)
		select
			@hibkills = kills,
			@hibdeathblows = death_blows,
			@hibsolokills = solo_kills 
		from openjson(@ResponseText, '$.realm_war_stats.current.player_kills.hibernia')
		with (
	
			kills int,
			deaths int,
			death_blows int,
			solo_kills int
		)
		select 
			@albkills = kills,
			@albdeathblows = death_blows,
			@albsolokills = solo_kills	
		from openjson(@ResponseText, '$.realm_war_stats.current.player_kills.albion')
		with (
	
			kills int,
			deaths int,
			death_blows int,
			solo_kills int
		)

		insert into characterrealmstats values (
		@charid,@realmpoints,@bountpoints, @totalkills,	@totaldeaths, @totaldeathblows, @totalsolokills, @midkills, @middeathblows,
			@midsolokills, @hibkills, @hibdeathblows, @hibsolokills, @albkills, @albdeathblows, @albsolokills, @importdate, NULL, null,1)

	exec sp_OADestroy @Object

	FETCH NEXT FROM char_cursor
	INTO @charid
	END
	CLOSE char_cursor
	DEALLOCATE char_cursor
	
	
update a
set a.dailyrealmpoints = a.realmpoints - b.realmpoints,
	a.dailydeaths = a.totaldeaths - b.totaldeaths
	--select count(*)
from characterrealmstats a
join characterrealmstats b
on a.character_web_id = b.character_web_id
and a.importdate =dateadd(day,1,b.importdate)
and a.importdate = @importdate



update a
set a.lastrecordflag = 0
from characterrealmstats a
cross apply
(
	select *
	from characterrealmstats b
	where a.character_web_id = b.character_web_id
	and b.importdate > a.importdate
	and b.lastrecordflag = 1
) b
where a.lastrecordflag = 1


RETURN 0 
GO
/****** Object:  StoredProcedure [dbo].[ImportAllGuildRosters]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ImportAllGuildRosters] 

AS


DECLARE 
    @guild_web_id VARCHAR(100)

DECLARE guild_cursor CURSOR FOR 
SELECT guild_web_id        
FROM guilds

OPEN guild_cursor;

FETCH NEXT FROM guild_cursor INTO @guild_web_id;

WHILE @@FETCH_STATUS = 0
    BEGIN
        
		exec ImportGuildRoster @guild_web_id
       
	   FETCH NEXT FROM guild_cursor INTO @guild_web_id

    END;

CLOSE guild_cursor;

DEALLOCATE guild_cursor;


return
GO
/****** Object:  StoredProcedure [dbo].[ImportAllianceGuilds]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportAllianceGuilds] 
    @guildid  varchar(100)
AS

/*
Make API Call

*/	
drop table if exists #tempresponse

declare	@url varchar(max)
create table #tempresponse (response varchar(max))
set @url = concat('https://api.camelotherald.com/guild/info/',@guildid)

Declare @Object as Int;
Declare @ResponseText as nVarchar(max);

Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
Exec sp_OAMethod @Object, 'open', NULL, 'get',
		@URL,
		'False'
Exec sp_OAMethod @Object, 'send'
insert into #tempresponse
Exec sp_OAMethod @Object, 'responseText'--, @ResponseText OUTPUT
exec sp_OADestroy @Object
--select * from #tempresponse


select @ResponseText = response from #tempresponse
insert into bloblogging select @url, @ResponseText, getdate()
insert into guilds
select *, 0 as importedflag
from openjson(@ResponseText, N'$.alliance.alliance_members') 

with
(
	guild_web_id varchar(100),
	name varchar(max)
) as a
where not exists
(
	select *
	from guilds b
	where a.guild_web_id = b.guild_web_id
)
union all

select *, 0 as importedflag
from openjson(@ResponseText, N'$.alliance.alliance_leader') 

with
(
	guild_web_id varchar(100),
	name varchar(max)
) as a
where not exists
(
	select *
	from guilds b
	where a.guild_web_id = b.guild_web_id
)

   drop table if exists #tempresponse
RETURN  
GO
/****** Object:  StoredProcedure [dbo].[ImportGuild]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[ImportGuild] 
    @guildid  varchar(100)
AS

/*
Make API Call

*/	
drop table if exists #tempresponse

declare	@url varchar(max)
create table #tempresponse (response varchar(max))
set @url = concat('https://api.camelotherald.com/guild/info/',@guildid)

Declare @Object as Int;
Declare @ResponseText as nVarchar(max);

Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
Exec sp_OAMethod @Object, 'open', NULL, 'get',
		@URL,
		'False'
Exec sp_OAMethod @Object, 'send'
insert into #tempresponse
Exec sp_OAMethod @Object, 'responseText'--, @ResponseText OUTPUT

--select * from #tempresponse


select @ResponseText = response from #tempresponse
insert into guilds
select *, 0 as importedflag
from openjson(@ResponseText) 
with
(
	guild_web_id varchar(100),
	name varchar(max)
) as a
where not exists
(
	select *
	from guilds b
	where a.guild_web_id = b.guild_web_id
)


   
RETURN  
GO
/****** Object:  StoredProcedure [dbo].[ImportGuildRoster]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportGuildRoster] 
    @guildid varchar(200)
AS
DECLARE 
@pageNumber int = 0,
@cnt int = 0,
@break int = 0



while (@pageNumber < 100 and @break = 0)
begin

drop table if exists #CharactersImport
drop table if exists #tempresponse
create table #tempresponse (response varchar(max))
declare @URL NVARCHAR(MAX) = concat('https://api.camelotherald.com/guild/roster/',@guildid ,'?pageNumber=',@pageNumber, '&sortType=REALM_POINTS&perPage=1000')

Declare @Object as Int;
Declare @ResponseText as nVarchar(max);

Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
Exec sp_OAMethod @Object, 'open', NULL, 'get',
       @URL,
       'False'

Exec sp_OAMethod @Object, 'send'

insert into #tempresponse
Exec sp_OAMethod @Object, 'responseText'--, @ResponseText OUTPUT
select @ResponseText = response from #tempresponse

exec sp_OADestroy @Object
/*
Declare @JSON varchar(max)

select @JSON= value
--select *
from openjson(@ResponseText)
where [key] = 'roster'
*/

select *
into #CharactersImport
from openjson(@ResponseText, '$.roster')
with
(
character_web_id nvarchar(4000),           
name  nvarchar(4000),     
server_name     nvarchar(4000),   
archived nvarchar(4000),
realm nvarchar(4000),
race nvarchar(4000),
class_name nvarchar(4000),
level          nvarchar(4000),
last_on_range int,
realm_points     nvarchar(4000),
guild_rank nvarchar(4000)
)

insert into Characters
select 
	character_web_id, 
	name, 
	case 
		when charindex(' ',name) > 0
			then left(name,charindex(' ',name))
		else name
	end,
	server_name, 
	archived,
	realm,
	race,
	case 
		when class_name = 'huntress' then 'hunter'
		when class_name = 'Enchantress' then 'Enchanter'
		when class_name = 'Heroine' then 'Hero'
		when class_name = 'Sorceress' then 'Sorcerer'
		else class_name
	end,
	level,
	last_on_range, 
	realm_points, 
	guild_rank,
	@guildid, 
	0 as watchlistflag,
	getdate() from #CharactersImport a
--where last_on_range not in (4,5) --Inactive -- Unknown
where not exists
(
	select *
	from Characters b
	where a.character_web_id = b.character_web_id
)

update a
set 
	name = b.name,
	firstname = case 
		when charindex(' ',b.name) > 0
			then left(b.name,charindex(' ',b.name))
		else b.name
	end,
	server_name = b.server_name,
	archived = b.archived,
	realm = b.realm,
	race = b.race,
	class_name = case 
					when b.class_name = 'huntress' then 'hunter'
					when b.class_name = 'Enchantress' then 'Enchanter'
					when b.class_name = 'Heroine' then 'Hero'
					when b.class_name = 'Sorceress' then 'Sorcerer'
					else b.class_name
				 end,
	level = b.level,
	last_on_range = b.last_on_range,
	realm_points = b.realm_points,
	guild_rank = b.guild_rank,
	guild_web_id = @guildid
from Characters a
join #CharactersImport b
on a.character_web_id = b.character_web_id



if @@ROWCOUNT = 0
begin
Set @break = 1
end




Set @pageNumber = @pageNumber + 1


end

update guilds
set importedflag = 1
where guild_web_id = @guildid

RETURN 0 


GO
/****** Object:  StoredProcedure [dbo].[TopRealmPoints]    Script Date: 2/7/2024 2:08:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TopRealmPoints]
    @class varchar(100) = null

AS
    select top 10  c.name as [Name], c.class_name as [Class], isnull(max(crs.realmpoints),max(c.realm_points)) as [Realm Points]
	from characters c
	left join characterrealmstats crs 
	on c.character_Web_id = crs.character_Web_id
	where @class = class_name
	or @class is null
	group by c.name, c.class_name
	order by 3 desc

RETURN 0 

GO
USE [master]
GO
ALTER DATABASE [daoctracking] SET  READ_WRITE 
GO
