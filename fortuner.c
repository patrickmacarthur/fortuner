/* fortuner.c
 * Patrick MacArthur <generalpenguin89@gmail.com>
 * Displays a fortune as a notification using the GNOME libnotify
 * library.
 */

#define _POSIX_C_SOURCE 200112L
#define _ISOC99_SOURCE
#define _XOPEN_SOURCE 600

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <glib.h>
#include <libnotify/notify.h>
#include <sys/wait.h>

/* Runs the 'fortune' program and puts its output into the buffer specified by
 * buf. */
int run_fortune(char *buf, int bufsize)
{
	int pipefds[2];
	int dupstdout;
	int offset;
	int bytes;
	pid_t pid;
	int status;
	int retval;

	pipe(pipefds);

	fflush(stdout);
	dupstdout = dup(STDOUT_FILENO);
	close(STDOUT_FILENO);
	dup(pipefds[1]);
	close(pipefds[1]);

	if ((pid = fork()) == 0) {
		close(pipefds[0]);
		execlp("fortune", "fortuner", NULL);
		exit(1);
	} else {
		close(STDOUT_FILENO);
		dup(dupstdout);

		offset = 0;
		while (offset < bufsize && (bytes = read(pipefds[0],
					buf + offset, bufsize - offset)) > 0) {
			offset += bytes;
		}

		if (bytes < 0) {
			perror("read");
			retval = -1;
		} else {
			buf[offset] = '\0';
			retval = 0;
		}

		if (waitpid(pid, &status, 0) == (pid_t)-1) {
			perror("waitpid");
			retval = -1;
		}

		if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
			return retval;
		} else {
			return -1;
		}
	}
}

#define BUFSIZE 10000

int main()
{
	gboolean status;
	NotifyNotification *notification;
	char *fortune;
	GError *error;

	status = notify_init("fortuner");
	if (!status) {
		return 1;
	}

	fortune = malloc(BUFSIZE + 1);
	if (!run_fortune(fortune, BUFSIZE)) {
		notification = notify_notification_new("Today's Fortune",
								fortune, NULL);
		status = notify_notification_show(notification, &error);
		if (!status) {
			fprintf(stderr, "Oops!\n");
		}
	}

	notify_uninit();
	return 0;
}

/* vim: set shiftwidth=8 tabstop=8 noexpandtab : */
