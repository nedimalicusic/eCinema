using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class MovieActorsValidator : AbstractValidator<MovieActorsUpsertDto>
    {
        public MovieActorsValidator()
        {
            RuleFor(c => c.MovieId).NotNull();
            RuleFor(c => c.ActorId).NotNull();
        }
    }
}
