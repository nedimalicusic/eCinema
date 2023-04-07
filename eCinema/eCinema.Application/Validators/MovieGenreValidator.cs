using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class MovieGenreValidator : AbstractValidator<MovieGenreUpsertDto>
    {
        public MovieGenreValidator()
        {
            RuleFor(c => c.MovieId).NotNull();
            RuleFor(c => c.GenreId).NotNull();
        }
    }
}
