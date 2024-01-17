using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class MovieGenreValidator : AbstractValidator<MovieGenreUpsertDto>
    {
        public MovieGenreValidator()
        {
            RuleFor(c => c.MovieId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.GenreId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
