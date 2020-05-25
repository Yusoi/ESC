/*
 * Generated by dtrace(8).
 */

#ifndef	_HEATTIMER_H
#define	_HEATTIMER_H

#include <unistd.h>

#ifdef	__cplusplus
extern "C" {
#endif

#if _DTRACE_VERSION

#define	HEATTIMER_QUERY_END_ITERATION() \
	__dtrace_heattimer___query__end_iteration()
#ifndef	__sparc
#define	HEATTIMER_QUERY_END_ITERATION_ENABLED() \
	__dtraceenabled_heattimer___query__end_iteration()
#else
#define	HEATTIMER_QUERY_END_ITERATION_ENABLED() \
	__dtraceenabled_heattimer___query__end_iteration(0)
#endif
#define	HEATTIMER_QUERY_MATRIX_GENERATION(arg0) \
	__dtrace_heattimer___query__matrix_generation(arg0)
#ifndef	__sparc
#define	HEATTIMER_QUERY_MATRIX_GENERATION_ENABLED() \
	__dtraceenabled_heattimer___query__matrix_generation()
#else
#define	HEATTIMER_QUERY_MATRIX_GENERATION_ENABLED() \
	__dtraceenabled_heattimer___query__matrix_generation(0)
#endif
#define	HEATTIMER_QUERY_START_COPY(arg0) \
	__dtrace_heattimer___query__start_copy(arg0)
#ifndef	__sparc
#define	HEATTIMER_QUERY_START_COPY_ENABLED() \
	__dtraceenabled_heattimer___query__start_copy()
#else
#define	HEATTIMER_QUERY_START_COPY_ENABLED() \
	__dtraceenabled_heattimer___query__start_copy(0)
#endif
#define	HEATTIMER_QUERY_START_ITERATION(arg0) \
	__dtrace_heattimer___query__start_iteration(arg0)
#ifndef	__sparc
#define	HEATTIMER_QUERY_START_ITERATION_ENABLED() \
	__dtraceenabled_heattimer___query__start_iteration()
#else
#define	HEATTIMER_QUERY_START_ITERATION_ENABLED() \
	__dtraceenabled_heattimer___query__start_iteration(0)
#endif


extern void __dtrace_heattimer___query__end_iteration(void);
#ifndef	__sparc
extern int __dtraceenabled_heattimer___query__end_iteration(void);
#else
extern int __dtraceenabled_heattimer___query__end_iteration(long);
#endif
extern void __dtrace_heattimer___query__matrix_generation(int);
#ifndef	__sparc
extern int __dtraceenabled_heattimer___query__matrix_generation(void);
#else
extern int __dtraceenabled_heattimer___query__matrix_generation(long);
#endif
extern void __dtrace_heattimer___query__start_copy(int);
#ifndef	__sparc
extern int __dtraceenabled_heattimer___query__start_copy(void);
#else
extern int __dtraceenabled_heattimer___query__start_copy(long);
#endif
extern void __dtrace_heattimer___query__start_iteration(int);
#ifndef	__sparc
extern int __dtraceenabled_heattimer___query__start_iteration(void);
#else
extern int __dtraceenabled_heattimer___query__start_iteration(long);
#endif

#else

#define	HEATTIMER_QUERY_END_ITERATION()
#define	HEATTIMER_QUERY_END_ITERATION_ENABLED() (0)
#define	HEATTIMER_QUERY_MATRIX_GENERATION(arg0)
#define	HEATTIMER_QUERY_MATRIX_GENERATION_ENABLED() (0)
#define	HEATTIMER_QUERY_START_COPY(arg0)
#define	HEATTIMER_QUERY_START_COPY_ENABLED() (0)
#define	HEATTIMER_QUERY_START_ITERATION(arg0)
#define	HEATTIMER_QUERY_START_ITERATION_ENABLED() (0)

#endif


#ifdef	__cplusplus
}
#endif

#endif	/* _HEATTIMER_H */
